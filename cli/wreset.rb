# encoding: utf-8

require 'simple_command_line_parser'
require 'blackstack-deployer'
require_relative './deployment-routines/all-routines'

l = BlackStack::BaseLogger.new(nil)
commands = []

# 
parser = BlackStack::SimpleCommandLineParser.new(
  :description => 'This command will launch a Sinatra-based BlackStack webserver.', 
  :configuration => [{

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
  # web server installation
    :name=>'web_port', 
    :mandatory=>false, 
    :description=>'Listening port for the Sinatra webserver.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default => 81,
  }]
)

#value = BlackStack::Deployer::NodeModule::eth0_ip(parser.value('laninterface'))
#puts '....'+value.to_s
#exit(0)

# validation: check if ssh_password or ssh_private_key_file is specified
raise 'Either ssh_password or ssh_private_key_file must be specified.' if parser.value('ssh_password').to_s=='-' && parser.value('ssh_private_key_file').to_s.size=='-'

# TODO: fix this when the issue https://github.com/leandrosardi/simple_command_line_parser/issues/6 is fixed.
ssh_password = parser.value('ssh_password').to_s=='-' ? nil : parser.value('ssh_password').to_s
ssh_private_key_file = parser.value('ssh_private_key_file').to_s=='-' ? nil : parser.value('ssh_private_key_file').to_s

# declare nodes
BlackStack::Deployer::add_nodes([{
    # use this command to connect from terminal: ssh -i "plank.pem" ubuntu@ec2-34-234-83-88.compute-1.amazonaws.com
    :name => 'my-dev-environment',
 
    # ssh
    :net_remote_ip => parser.value('ssh_hostname'),  
    :ssh_username => parser.value('ssh_username'),
    :ssh_port => parser.value('ssh_port'),
    :ssh_password => ssh_password,
    :ssh_private_key_file => ssh_private_key_file,
 
    # sinatra
    :web_port => parser.value('web_port'),

    # default deployment routine for this node
    :deployment_routine => 'install-mysaas-dev-environment',
}])

commands += [
  # start cockroachdb node
  { :command => :'start-mysaas', },
]

# deploy
l.logs 'Starting web server... '
BlackStack::Deployer::run_routine('my-dev-environment', 'start-mysaas')
l.done