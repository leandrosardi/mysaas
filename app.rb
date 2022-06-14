require 'sinatra'
require 'lib/core'
require 'lib/stub'
require 'config'
require 'version'
DB = BlackStack::Core::CRDB::connect
require 'lib/skeleton'

# map params key-values to session key-values.
# for security: the keys `:password` and `:new_password` are not mapped.
def params_to_session
  params.each do |key, value|
    session[key] = value if key != :password && key != :new_password
  end
end

# Helper: get the real user who is logged in.
# If this account is accessded by an operator, return the [user] object of such an operator.
# Otherwise, return the logged-in [user].
def real_user
  login = BlackStack::Core::Login.where(:id=>session['login.id']).first
  uid = !session['login.id_prisma_user'].nil? ? session['login.id_prisma_user'] : login.user.id
  BlackStack::Core::User.where(:id=>uid).first
end # def real_user

# Helper: User preferences
# Store/Retrieve a shadow parameter of a user.
# If the accounts is accessed from PRISMA, by an operator, manage the shadow profile of such an operator.
# Otherwise, manage the shadow profile of the logged in user.
def shadow(name, params, x, verbose=false)
  id_prisma_user = session['login.id_prisma_user']
  if id_prisma_user.to_s.size == 0
    return @login.user.shadow(name, params, x, verbose)
  else
    u = BlackStack::Core::User.where(:id => id_prisma_user).first
    return u.shadow(name, params, x, verbose)
  end
end # def shadow

# Helper: create file ./.maintenance if you want to disable internal pages in the member area
def unavailable?
  f = File.exist?(File.expand_path(__FILE__).gsub('/app.rb', '') + '/.maintenance')
end

# Helper: create file ./.notrial if you want to switch to another landing
def notrial?
  f = File.exist?(File.expand_path(__FILE__).gsub('/app.rb', '') + '/.notrial')
end

# Helper: return true if there is a user logged into
def logged_in?
    !session['login.id'].nil?
end

# Helper: return the user browser
def browser?
  agent = params[:agent]
  user_agent = UserAgentParser.parse agent
  
  if (user_agent.family.to_s == "Chrome")
    return true
  elsif (user_agent.family.to_s == "Firefox" && user_agent.version.major.to_i>=4)
    return true
  elsif (user_agent.family.to_s == "Firefox" && user_agent.version.major.to_i<4)
    return false
  elsif (user_agent.family.to_s == "Safari" && user_agent.version.major.to_i>=5)
    return true
  elsif (user_agent.family.to_s == "Safari" && user_agent.version.major.to_i<5)
    return false
  elsif (user_agent.family.to_s == "Opera" && user_agent.version.major.to_i>=11)
    return true
  elsif (user_agent.family.to_s == "Opera" && user_agent.version.major.to_i<11)
    return false
  elsif (user_agent.family.to_s == "IE" && user_agent.version.major.to_i>=9)
    return true
  elsif (user_agent.family.to_s == "IE" && user_agent.version.major.to_i<9)
    return false
  else
    return false
  end
end

# 
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

PORT = parser.value("port")

configure { set :server, :puma }
set :public_folder, 'public'
set :bind, '0.0.0.0'
set :port, PORT
enable :sessions
enable :static

# page not found redirection
not_found do
  redirect "/404?url=#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}#{CGI::escape(request.path_info)}"
end

# unhandled exception redirectiopn
error do
  max_lenght = 8000
  s = "message=#{CGI.escape(env['sinatra.error'].to_s)}&"
  s += "backtrace_size=#{CGI.escape(env['sinatra.error'].backtrace.size.to_s)}&"
  i = 0
  env['sinatra.error'].backtrace.each { |a| 
    a = "backtrace[#{i.to_s}]=#{CGI.escape(a.to_s)}&"
    and_more = "backtrace[#{i.to_s}]=..." 
    if (s+a).size > max_lenght - and_more.size
      s += and_more
      break
    else
      s += a
    end
    i += 1 
  }
  redirect "/500?#{s}"
end

# condition: if there is not authenticated user on the platform, then redirect to the signup page 
set(:auth1) do |*roles|
  condition do
    if !logged_in?
      redirect "/login?redirect=#{CGI.escape(request.path_info.to_s)}%3F#{CGI.escape(request.query_string)}"
    elsif unavailable?
      redirect "/unavailable"      
    else
      @login = BlackStack::Core::Login.where(:id=>session['login.id']).first
    end
  end
end

# condition: api_key parameter is required too for the access points
set(:api_key) do |*roles|
  condition do
    return_message = {}
    
    if !params.has_key?('api_key')
      # libero recursos
      DB.disconnect 
      GC.start
      return_message[:status] = 'api_key is required'
      return_message[:value] = ""
      halt return_message.to_json
    end

    if !params['api_key'].guid?
      # libero recursos
      DB.disconnect 
      GC.start
  
      return_message[:status] = 'Invalid api_key'
      return_message[:value] = ""
      halt return_message.to_json      
    end
    
    validation_api_key = params['api_key'].to_guid
    
    validation_client = BlackStack::Core::Account.where(:api_key => validation_api_key).first
    if validation_client.nil?
      # libero recursos
      DB.disconnect 
      GC.start
      #     
      return_message[:status] = 'Api_key not found'
      return_message[:value] = ""
      halt return_message.to_json        
    end
  end
end

=begin

# TODO: develop these methods on the lib folder

# si el cliente tiene configurada una cuenta reseller,
# y un operador esta accediendo a esta cuenta,
# entonces no muestro.
#
# No puede ser un metodo de la clase User, porque accede a las variables de sesion del webserver.
def getEmailToShow(user)
  if user.account.resellerSignature? && session['login.id_prisma_user'].to_s.size > 0
    if user.account.user_to_contect == nil
      return "****@****.***"
    elsif user.account.user_to_contect.id != user.id
      return "****@****.***"
    end
  end
  user.email
end
=end

def nav1(name1, beta=false)
  login = BlackStack::Core::Login.where(:id=>session['login.id']).first
  user = BlackStack::Core::User.where(:id=>login.id_user).first  

  ret = 
  "<p>" + 
  "<a class='simple' href='/settings/account'><b>#{CGI.escapeHTML(user.account.name.encode_html)}</b></a>" + 
  " <i class='icon-chevron-right'></i> " + 
  CGI.escapeHTML(name1)

  ret += "  <span class='badge badge-mini badge-important'>beta</span>" if beta
  
  ret += "</p>"
end

def nav2(name1, url1, name2)
  login = BlackStack::Core::Login.where(:id=>session['login.id']).first
  user = BlackStack::Core::User.where(:id=>login.id_user).first  

  "<p>" + 
  "<a class='simple' href='/settings/account'><b>#{user.account.name.encode_html}</b></a>" + 
  " <i class='icon-chevron-right'></i> " + 
  "<a class='simple' href='#{url1}'>#{CGI.escapeHTML(name1)}</a>" + 
  " <i class='icon-chevron-right'></i> " + 
  CGI.escapeHTML(name2) +
  "</p>"
end

def nav3(name1, url1, name2, url2, name3)
  login = BlackStack::Core::Login.where(:id=>session['login.id']).first
  user = BlackStack::Core::User.where(:id=>login.id_user).first  
  "<p>" + 
  "<a class='simple' href='/settings/account'><b>#{user.account.name.encode_html}</b></a>" + 
  " <i class='icon-chevron-right'></i> " + 
  "<a class='simple' href='#{url1}'>#{CGI.escapeHTML(name1)}</a>" + 
  " <i class='icon-chevron-right'></i> " + 
  "<a class='simple' href='#{url2}'>#{CGI.escapeHTML(name2)}</a>" + 
  " <i class='icon-chevron-right'></i> " + 
  name3 +
  "</p>"
end

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# External pages: pages that don't require login

# TODO: here where you have to develop notrial? feature
get '/', :agent => /(.*)/ do
  if !notrial?
    erb :'/waiting' #, :layout => :'/layouts/public'
  else
    erb :'/waiting' #, :layout => :'/layouts/public'
  end
end

get '/404', :agent => /(.*)/ do
  erb :'404', :layout => :'/layouts/public'
end

get '/500', :agent => /(.*)/ do
  erb :'500', :layout => :'/layouts/public'
end

get '/login', :agent => /(.*)/ do
  erb :login, :layout => :'/layouts/public'
end
post '/login' do
  erb :filter_login
end
get '/filter_login' do
  erb :filter_login
end

get '/signup', :agent => /(.*)/ do
  erb :signup, :layout => :'/layouts/public'
end
post '/signup' do
  erb :filter_signup
end

get '/confirm/:nid' do
  erb :filter_confirm
end

get '/logout' do
  erb :filter_logout
end


get '/recover', :agent => /(.*)/ do
  erb :recover, :layout => :'/layouts/public'
end
post '/recover' do
  erb :filter_recover
end

get '/reset/:nid', :agent => /(.*)/ do
  erb :reset, :layout => :'/layouts/public'
end
post '/reset' do
  erb :filter_reset
end

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# User dashboard

get '/', :auth1 => true do
  redirect '/dashboard'
end
get '/dashboard', :auth1 => true, :agent => /(.*)/ do
  erb :'/dashboard', :layout => :'/layouts/core'
end


# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Configuration screens

# main configuration screen
get '/settings', :auth1 => true do
  redirect '/settings/dashboard'
end
get '/settings/', :auth1 => true do
  redirect '/settings/dashboard'
end
get '/settings/dashboard', :auth1 => true, :agent => /(.*)/ do
  erb :'/settings/dashboard', :layout => :'/layouts/core'
end

# account information
get '/settings/account', :auth1 => true, :agent => /(.*)/ do
  erb :'/settings/account', :layout => :'/layouts/core'
end
post '/settings/filter_account', :auth1 => true do
  erb :'/settings/filter_account'
end

# change password
get '/settings/password', :auth1 => true, :agent => /(.*)/ do
  erb :'/settings/password', :layout => :'/layouts/core'
end
post '/settings/filter_password', :auth1 => true do
  erb :'/settings/filter_password'
end

# change password
get '/settings/apikey', :auth1 => true, :agent => /(.*)/ do
  erb :'/settings/apikey', :layout => :'/layouts/core'
end
post '/settings/filter_apikey', :auth1 => true do
  erb :'/settings/filter_apikey'
end

## users management screen
get '/settings/users', :auth1 => true, :agent => /(.*)/ do
  erb :'/settings/users', :layout => :'/layouts/core'
end
post '/settings/filter_users_add', :auth1 => true do
  erb :'/settings/filter_users_add'
end
post '/settings/filter_users_delete', :auth1 => true do
  erb :'/settings/filter_users_delete'
end
post '/settings/filter_users_update', :auth1 => true do
  erb :'/settings/filter_users_update'
end
post '/settings/filter_users_send_confirmation_email', :auth1 => true do
  erb :'/settings/filter_users_send_confirmation_email'
end

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# API access points

get '/api1.0' do
  redirect 'https://help.expandedventure.com/developers'
end

get '/api1.0/' do
  redirect 'https://help.expandedventure.com/developers'
end

# ping
get '/api1.0/ping.json', :api_key => true do
  erb :'/api1.0/ping'
end
post '/api1.0/ping.json', :api_key => true do
  erb :'/api1.0/ping'
end
