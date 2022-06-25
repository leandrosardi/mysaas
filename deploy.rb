# encoding: utf-8
require 'mysaas'
require 'lib/stubs'
require_relative '../blackstack-deployer/lib/blackstack-deployer' # enable this line if you want to work with a live version of deployer
require_relative '../blackstack-nodes/lib/blackstack-nodes' # enable this line if you want to work with a live version of nodes
require 'config'
require 'version'
require_relative './deployment-routines/all-routines'

l = BlackStack::BaseLogger.new(nil)

# 
parser = BlackStack::SimpleCommandLineParser.new(
  :description => 'This command will launch a Sinatra-based BlackStack webserver.', 
  :configuration => [{
  # installation options
    :name=>'web', 
    :mandatory=>false, 
    :description=>'Enable or disable the installation and running of the web server.', 
    :type=>BlackStack::SimpleCommandLineParser::BOOL,
    :default => true,
  }, {
    :name=>'db', 
    :mandatory=>false, 
    :description=>'Enable or disable the installation and running of the cockroachdb server, with the creation of the schema and seed of the tables.', 
    :type=>BlackStack::SimpleCommandLineParser::BOOL,
    :default => true,
  }]
)

# run database updates
if parser.value('db')
  l.logs 'Connecting the database... '
  BlackStack::Deployer::DB::connect(
    BlackStack::CRDB::connection_string # use the connection parameters setting in ./config.rb
  )
  l.done

  l.logs 'Loading checkpoint... '
  BlackStack::Deployer::DB::load_checkpoint
  l.logf "done (#{BlackStack::Deployer::DB::checkpoint.to_s})"

  l.logs 'Running database updates... '
  BlackStack::Deployer::DB::set_folder ('./sql')
  BlackStack::Deployer::DB::deploy(true)
  l.done

  # run the .sql scripts of each extension
  BlackStack::Extensions.extensions.each { |e|
    l.logs "Loading checkpoint for #{e.name.downcase}... "
    BlackStack::Deployer::DB::load_checkpoint("./blackstack-deployer.#{e.name.downcase}.lock")
    l.logf "done (#{BlackStack::Deployer::DB::checkpoint.to_s})"

    l.logs "Running database updates for #{e.name.downcase}... "
    BlackStack::Deployer::DB::set_folder ("./extensions/#{e.name.downcase}/sql")
    BlackStack::Deployer::DB::deploy(true, "./blackstack-deployer.#{e.name.downcase}.lock")
    l.done
  }
end # if parser.value('db')

# restart webserver
# Reference: https://stackoverflow.com/questions/3430330/best-way-to-make-a-shell-script-daemon
if parser.value('web')

  # TODO: pull source code of extensions extensions 

  l.logs 'Upload config.rb... '
  BlackStack::Deployer::run_routine('sinatra1', 'setup-mysaas-upload-config')
  l.done

  l.logs 'Update source code & gems... '
  BlackStack::Deployer::run_routine('sinatra1', 'install-mysaas')
  l.done

  l.logs 'Starting web server... '
  BlackStack::Deployer::run_routine('sinatra1', 'start-mysaas')
  l.done
end # if parser.value('web')
