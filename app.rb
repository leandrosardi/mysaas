require 'sinatra'
require 'mysaas'
require 'lib/stubs'
require 'config'
require 'version'
DB = BlackStack::CRDB::connect
require 'lib/skeletons'

# enable this line if you want to work with the live version of blackstack-core.
#require_relative '../blackstack-core/lib/blackstack-core' 

puts "

Welcome to MySaaS v#{BLACKSTACK_VERSION}.

Sandbox Environment: #{SANDBOX.to_s}.

"

# include the libraries of the extensions
# reference: https://github.com/leandrosardi/mysaas/issues/33
BlackStack::Extensions.extensions.each { |e|
  require "extensions/#{e.name.downcase}/#{e.name.downcase}"
}

# TODO: move this to the extension module?
Leads.server_side

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
set :bind, '0.0.0.0'
set :port, PORT
enable :sessions
enable :static

# Setting the root of views and public folders in the `~/code` folder in order to have access to extensions.
# reference: https://stackoverflow.com/questions/69028408/change-sinatra-views-directory-location
set :root,  File.dirname(__FILE__)
set :views, Proc.new { File.join(root) }

# Setting the public directory of MySaaS, and the public directories of all the extensions.
# Public folder is where we store the files who are referenced from HTML (images, CSS, JS, fonts).
# reference: https://stackoverflow.com/questions/18966318/sinatra-multiple-public-directories
# reference: https://github.com/leandrosardi/mysaas/issues/33
use Rack::TryStatic, :root => 'public', :urls => %w[/]
BlackStack::Extensions.extensions.each { |e|
  use Rack::TryStatic, :root => "extensions/#{e.name.downcase}/public", :urls => %w[/]
}

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
set(:auth) do |*roles|
  condition do
    if !logged_in?
      redirect "/login?redirect=#{CGI.escape(request.path_info.to_s)}%3F#{CGI.escape(request.query_string)}"
    elsif unavailable?
      redirect "/unavailable"      
    else
      @login = BlackStack::MySaaS::Login.where(:id=>session['login.id']).first
    end
  end
end

# condition: api_key parameter is required too for the access points
set(:api_key) do |*roles|
  condition do
    @return_message = {}
    
    @return_message[:status] = 'success'

    # validate: the pages using the :api_key condition must work as post only.
    if request.request_method != 'POST'
      @return_message[:status] = 'Pages with and `api_key` parameter are only available for POST requests.'
      @return_message[:value] = ""
      halt @return_message.to_json
    end

    # when ruby pushes hash of hashes (or hash of arrays), all values are converted into strings.
    # and arrays are mapped to the last element only.
    # reference: https://github.com/leandrosardi/mysaas/issues/59
    # 
    # iterate the keys of the hash
    params.each do |key, value|
      # convert the value to json
      # reference: https://stackoverflow.com/questions/1667630/how-do-i-convert-a-string-object-into-a-hash-object
      begin
      params[key] = eval(value)
      rescue Exception => e
      rescue SyntaxError => e
          # do nothing
          # Example: if value='hello', you the eval will raise SyntaxError.
          # Eval will work when value is an array or hash converted to string.
      end
    end

    if !params.has_key?('api_key')
      # libero recursos
      DB.disconnect 
      GC.start
      @return_message[:status] = 'api_key is required'
      @return_message[:value] = ""
      halt @return_message.to_json
    end

    if !params['api_key'].guid?
      # libero recursos
      DB.disconnect 
      GC.start
  
      @return_message[:status] = 'Invalid api_key'
      @return_message[:value] = ""
      halt @return_message.to_json      
    end
    
    validation_api_key = params['api_key'].to_guid.downcase

    @account = BlackStack::MySaaS::Account.where(:api_key => validation_api_key).first
    if @account.nil?
      # libero recursos
      DB.disconnect 
      GC.start
      #     
      @return_message[:status] = 'Api_key not found'
      @return_message[:value] = ""
      halt @return_message.to_json        
    end
  end
end

=begin

# TODO: develop these methods on the models folder

# si el cliente tiene configurada una cuenta reseller,
# y un operador esta accediendo a esta cuenta,
# entonces no muestro.
#
# No puede ser un metodo de la clase User, porque accede a las variables de sesion del webserver.
def getEmailToShow(user)
  if user.account.resellerSignature? && session['login.id_prisma_user'].to_s.size > 0
    if user.account.contact == nil
      return "****@****.***"
    elsif user.account.contact.id != user.id
      return "****@****.***"
    end
  end
  user.email
end
=end

def nav1(name1, beta=false)
  login = BlackStack::MySaaS::Login.where(:id=>session['login.id']).first
  user = BlackStack::MySaaS::User.where(:id=>login.id_user).first  

  ret = 
  "<p>" + 
  "<a class='simple' href='/settings/account'><b>#{CGI.escapeHTML(user.account.name.encode_html)}</b></a>" + 
  " <i class='icon-chevron-right'></i> " + 
  CGI.escapeHTML(name1)

  ret += "  <span class='badge badge-mini badge-important'>beta</span>" if beta
  
  ret += "</p>"
end

def nav2(name1, url1, name2)
  login = BlackStack::MySaaS::Login.where(:id=>session['login.id']).first
  user = BlackStack::MySaaS::User.where(:id=>login.id_user).first  

  "<p>" + 
  "<a class='simple' href='/settings/account'><b>#{user.account.name.encode_html}</b></a>" + 
  " <i class='icon-chevron-right'></i> " + 
  "<a class='simple' href='#{url1}'>#{CGI.escapeHTML(name1)}</a>" + 
  " <i class='icon-chevron-right'></i> " + 
  CGI.escapeHTML(name2) +
  "</p>"
end

def nav3(name1, url1, name2, url2, name3)
  login = BlackStack::MySaaS::Login.where(:id=>session['login.id']).first
  user = BlackStack::MySaaS::User.where(:id=>login.id_user).first  
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
# FreeLeadsData Extension
# TODO: move this as an extension
=begin
# define extensions path
path = '/home/leandro/code'

# name of the extension
name = 'leads'

# remove any from the project folder
FileUtils.rm_rf("./views/#{name}")

# copy leads extension to MySaaS folder
# ruby copy folder with subfolders to a target location
# reference: https://stackoverflow.com/questions/17469095/ruby-copy-folder-with-subfolders-to-a-target-location
FileUtils.copy_entry "#{path}/#{name}/views", "./views/#{name}"

#exit(0)

# define screens
get "/#{name}/exports", :auth => true do
  erb :"/#{name}/exports", :layout => :"/#{name}/views/layout"
end
=end
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# External pages: pages that don't require login

# TODO: here where you have to develop notrial? feature
get '/', :agent => /(.*)/ do
  if !notrial?
    erb :'views/waiting' #, :layout => :'/views/layouts/public'
  else
    erb :'views/waiting' #, :layout => :'/views/layouts/public'
  end
end

get '/404', :agent => /(.*)/ do
  erb :'views/404', :layout => :'/views/layouts/public'
end

get '/500', :agent => /(.*)/ do
  erb :'views/500', :layout => :'/views/layouts/public'
end

get '/login', :agent => /(.*)/ do
  erb :'views/login', :layout => :'/views/layouts/public'
end
post '/login' do
  erb :'views/filter_login'
end
get '/filter_login' do
  erb :'views/filter_login'
end

get '/signup', :agent => /(.*)/ do
  erb :'views/signup', :layout => :'/views/layouts/public'
end
post '/signup' do
  erb :'views/filter_signup'
end

get '/confirm/:nid' do
  erb :'views/filter_confirm'
end

get '/logout' do
  erb :'views/filter_logout'
end


get '/recover', :agent => /(.*)/ do
  erb :'views/recover', :layout => :'/views/layouts/public'
end
post '/recover' do
  erb :'views/filter_recover'
end

get '/reset/:nid', :agent => /(.*)/ do
  erb :'views/reset', :layout => :'/views/layouts/public'
end
post '/reset' do
  erb :'views/filter_reset'
end

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# User dashboard

get '/', :auth => true do
  redirect '/dashboard'
end
get '/dashboard', :auth => true, :agent => /(.*)/ do
  erb :'views/dashboard', :layout => :'/views/layouts/core'
end


# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Configuration screens

# main configuration screen
get '/settings', :auth => true do
  redirect '/settings/dashboard'
end
get '/settings/', :auth => true do
  redirect '/settings/dashboard'
end
get '/settings/dashboard', :auth => true, :agent => /(.*)/ do
  erb :'views/settings/dashboard', :layout => :'/views/layouts/core'
end

# account information
get '/settings/account', :auth => true, :agent => /(.*)/ do
  erb :'views/settings/account', :layout => :'/views/layouts/core'
end
post '/settings/filter_account', :auth => true do
  erb :'views/settings/filter_account'
end

# change password
get '/settings/password', :auth => true, :agent => /(.*)/ do
  erb :'views/settings/password', :layout => :'/views/layouts/core'
end
post '/settings/filter_password', :auth => true do
  erb :'views/settings/filter_password'
end

# change password
get '/settings/apikey', :auth => true, :agent => /(.*)/ do
  erb :'views/settings/apikey', :layout => :'/views/layouts/core'
end
post '/settings/filter_apikey', :auth => true do
  erb :'views/settings/filter_apikey'
end

## users management screen
get '/settings/users', :auth => true, :agent => /(.*)/ do
  erb :'views/settings/users', :layout => :'/views/layouts/core'
end

get '/settings/filter_users_add', :auth => true do
  erb :'views/settings/filter_users_add'
end
post '/settings/filter_users_add', :auth => true do
  erb :'views/settings/filter_users_add'
end

get '/settings/filter_users_delete', :auth => true do
  erb :'views/settings/filter_users_delete'
end
post '/settings/filter_users_delete', :auth => true do
  erb :'views/settings/filter_users_delete'
end

get '/settings/filter_users_update', :auth => true do
  erb :'views/settings/filter_users_update'
end
post '/settings/filter_users_update', :auth => true do
  erb :'views/settings/filter_users_update'
end

get '/settings/filter_users_send_confirmation_email', :auth => true do
  erb :'views/settings/filter_users_send_confirmation_email'
end
post '/settings/filter_users_send_confirmation_email', :auth => true do
  erb :'views/settings/filter_users_send_confirmation_email'
end

get '/settings/filter_users_set_account_owner', :auth => true do
  erb :'views/settings/filter_users_set_account_owner'
end
post '/settings/filter_users_set_account_owner', :auth => true do
  erb :'views/settings/filter_users_set_account_owner'
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
  erb :'views/api1.0/ping'
end
post '/api1.0/ping.json', :api_key => true do
  erb :'views/api1.0/ping'
end

# --------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Require the app.rb file of each one of the extensions.
# reference: https://github.com/leandrosardi/mysaas/issues/33
BlackStack::Extensions.extensions.each { |e|
  require "extensions/#{e.name.downcase}/app.rb"
}
