# encoding: utf-8
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
require_relative './deployment-routines/all-routines'

l = BlackStack::BaseLogger.new(nil)

# 
parser = BlackStack::SimpleCommandLineParser.new(
  :description => 'This command will launch a Sinatra-based BlackStack webserver.', 
  :configuration => [{
=begin
  # ssh access
    :name=>'ssh_hostname', 
    :mandatory=>false, 
    :description=>'SSH IP address of the node where you want to install mysaas.', 
    :type=>BlackStack::SimpleCommandLineParser::STRING,
    :default => '127.0.0.1',
  }, {
    :name=>'ssh_port', 
    :mandatory=>false, 
    :description=>'SSH port of the node where you want to install mysaas.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default=>22,
  }, {
    :name=>'ssh_username', 
    :mandatory=>true, 
    :description=>'User to login the node via remote SSH.', 
    :type=>BlackStack::SimpleCommandLineParser::STRING,
  }, {
    :name=>'ssh_password', 
    :mandatory=>false, 
    :description=>'Password to login the node via remote SSH. Either ssh_password or ssh_private_key_file must be specified.', 
    :type=>BlackStack::SimpleCommandLineParser::STRING,
    :default => '-',
  }, {
    :name=>'ssh_private_key_file', 
    :mandatory=>false, 
    :description=>'Private key file to login the node via remote SSH. Either ssh_password or ssh_private_key_file must be specified.', 
    :type=>BlackStack::SimpleCommandLineParser::STRING,
    :default => '-',
  }, {
  # database installation
    :name=>'crdb_database_password', 
    :mandatory=>false, 
    :description=>'The password for the database user blackstack.', 
    :type=>BlackStack::SimpleCommandLineParser::STRING,
    :default => 'bsws2022',
  }, {
    :name=>'crdb_database_port', 
    :mandatory=>false, 
    :description=>'Listening port for the CockroachDB database.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default => 26257,
  }, {
    :name=>'crdb_dashboard_port', 
    :mandatory=>false, 
    :description=>'Listening port for the CockroachDB dashboard.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default => 8080,
  }, {
  # web server installation
    :name=>'web_port', 
    :mandatory=>false, 
    :description=>'Listening port for the Sinatra webserver.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default => 81,
  }, {
  # LAN interface
    :name=>'laninterface', 
    :mandatory=>false, 
    :description=>'The name of the LAN interface. Some services like CockroachDB need the IP address of the LAN interface.', 
    :type=>BlackStack::SimpleCommandLineParser::STRING,
    :default => 'eth0',
  }, {
=end
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
=begin
  }, {
    :name=>'local', 
    :mandatory=>false, 
    :description=>'Enable installing a server in your local machine for development. If this flag is activated, the connection to the database will be attempted to be to the lan IP of the computer. Otherwise, the connection will be attempted to `ssh_hostname`.', 
    :type=>BlackStack::SimpleCommandLineParser::BOOL,
    :default => false,
=end
  }]
)
=begin
#value = BlackStack::Deployer::NodeModule::eth0_ip(parser.value('laninterface'))
#puts '....'+value.to_s
#exit(0)

# validation: check if ssh_password or ssh_private_key_file is specified
raise 'Either ssh_password or ssh_private_key_file must be specified.' if parser.value('ssh_password').to_s=='-' && parser.value('ssh_private_key_file').to_s.size=='-'

# TODO: fix this when the issue https://github.com/leandrosardi/simple_command_line_parser/issues/6 is fixed.
ssh_password = parser.value('ssh_password').to_s=='-' ? nil : parser.value('ssh_password').to_s
ssh_private_key_file = parser.value('ssh_private_key_file').to_s=='-' ? nil : parser.value('ssh_private_key_file').to_s
crdb_hostname = parser.value('local') ? BlackStack::Deployer::NodeModule::eth0_ip(parser.value('laninterface')) : parser.value('ssh_hostname')
=end

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
  l.logs 'Upload config.rb... '
  BlackStack::Deployer::run_routine('sinatra1', 'setup-mysaas-upload-config')
  l.done

  l.logs 'Starting web server... '
  BlackStack::Deployer::run_routine('sinatra1', 'start-mysaas')
  l.done
end # if parser.value('web')
