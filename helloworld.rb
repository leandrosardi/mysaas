require 'sinatra'
require 'lib/core.rb'

parser = BlackStack::SimpleCommandLineParser.new(
  :description => 'This command will launch a Sinatra-based BlackStack webserver.', 
  :configuration => [{
    :name=>'port', 
    :mandatory=>false, 
    :description=>'Listening port.', 
    :type=>BlackStack::SimpleCommandLineParser::INT,
    :default => 80,
  }]
)

configure { set :server, :puma }
set :public_folder, 'public'
set :bind, '0.0.0.0'
set :port, parser.value("port")
enable :sessions
enable :static

get '/' do
  erb "Hello World!"
end
