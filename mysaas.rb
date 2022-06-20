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

