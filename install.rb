=begin
require 'net/ssh'

ssh = Net::SSH.start('54.197.146.193', 'ubuntu', :keys => './plank.pem', :port => 22)

s = "sudo cockroach sql --host 172.31.20.234:26257 --certs-dir certs -e \"CREATE USER blackstack WITH PASSWORD '%crdb_database_password%';\""
print "#{s}... "
puts ssh.exec!(s)

ssh.close

exit(0)
=end

# Example script of connecting to an AWS/EC2 instance using a key file; and running a command.

require 'simple_command_line_parser'
require 'blackstack-deployer'
require 'deployment-routines/all-routines'

l = BlackStack::BaseLogger.new(nil)

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

  # database installation
  }, {
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

  # installation options
  }, {
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

# validation: check if ssh_password or ssh_private_key_file is specified
raise 'Either ssh_password or ssh_private_key_file must be specified.' if parser.value('ssh_password').to_s=='-' && parser.value('ssh_private_key_file').to_s.size=='-'

# TODO: fix this when the issue https://github.com/leandrosardi/simple_command_line_parser/issues/6 is fixed.
ssh_password = parser.value('ssh_password').to_s=='-' ? nil : parser.value('ssh_password').to_s
ssh_private_key_file = parser.value('ssh_private_key_file').to_s=='-' ? nil : parser.value('ssh_private_key_file').to_s

# declare nodes
BlackStack::Deployer::add_nodes([{
    # use this command to connect from terminal: ssh -i "plank.pem" ubuntu@ec2-34-234-83-88.compute-1.amazonaws.com
    :name => 'my-dev-environment',
 
    # ssh access
    :net_remote_ip => parser.value('ssh_hostname'),  
    :ssh_username => parser.value('ssh_username'),
    :ssh_port => parser.value('ssh_port'),
    :ssh_password => ssh_password,
    :ssh_private_key_file => ssh_private_key_file,
 
    # git repository
    :git_branch => 'main',

    # cockroachdb access
    :crdb_database_certs_path => "/home/#{parser.value('ssh_username')}",
    :crdb_database_password => parser.value('crdb_database_password'),
    :crdb_database_port => parser.value('crdb_database_port'),
    :crdb_dashboard_port => parser.value('crdb_dashboard_port'),

    # default deployment routine for this node
    :deployment_routine => 'install-mysaas-dev-environment',
}])

commands = [
    # update and upgrade apt
    { :command => :'upgrade-packages', }, 
    # install some required packages
    { :command => :'install-packages', }, 
]

if parser.value('web')
  commands += [
    # install ruby
    { :command => :'install-ruby', }, 
    # pull the source code of mysaas
    { :command => :'install-mysaas', },
    # edit mysaas/config.rb
    { :command => :'setup-mysaas', },
    # TODO: start mysaas webserver
    # Reference: https://stackoverflow.com/questions/3430330/best-way-to-make-a-shell-script-daemon
  ]
end # parser.value('web')

if parser.value('db')
  commands += [
    # install cockroachdb node
    { :command => :'install-crdb-environment', },
    # start cockroachdb node
    { :command => :'start-crdb-environment', },
    # create user, database, tables and roles; and insert some seed data
    { :command => :'install-crdb-database', },
  ]
end # parser.value('db')

# setup deploying rutine
BlackStack::Deployer::add_routine({
  :name => 'install-mysaas-dev-environment',
  :commands => commands,
})

# deploy
BlackStack::Deployer::run_routine('my-dev-environment', 'install-mysaas-dev-environment')

if parser.value('db')
  # TODO: install database updates
end # if parser.value('db')
