require 'blackstack-core'
require 'simple_command_line_parser'
require 'simple_cloud_logging'
require 'blackstack-deployer'
require 'pg'
require 'sequel'
require 'bcrypt'
require 'mail'
require 'pry'
require 'cgi'
require 'fileutils'
require 'rack/contrib/try_static' # this is to manage many public folders

require 'lib/apis'
require 'lib/controllers'
require 'lib/databases'
require 'lib/emails'
require 'lib/extensions'
require 'lib/notifications'
require 'lib/storages'
require 'lib/tablehelper'
#require 'lib/skeletons'
#require 'lib/stubs'

# return a postgresql uuid
def guid()
    BlackStack::CRDB::guid
end
            
# return current datetime with format `YYYY-MM-DD HH:MM:SS`
def now()
    BlackStack::CRDB::now
end

# map params key-values to session key-values.
# for security: the keys `:password` and `:new_password` are not mapped.
def params_to_session(path=nil)
    params.each do |key, value|
      if path.nil?
        session[key.to_s] = value if key != :password && key != :new_password
      else
        session[path + '.' + key] = value if key != :password && key != :new_password
      end
    end
end

  # Helper: get the real user who is logged in.
# If this account is accessded by an operator, return the [user] object of such an operator.
# Otherwise, return the logged-in [user].
def real_user
    login = BlackStack::MySaaS::Login.where(:id=>session['login.id']).first
    uid = !session['login.id_prisma_user'].nil? ? session['login.id_prisma_user'] : login.user.id
    BlackStack::MySaaS::User.where(:id=>uid).first
end # def real_user
  
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