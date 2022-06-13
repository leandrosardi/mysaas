# load gem and connect database
require 'lib/core.rb'
require 'lib/stub.rb'
require 'config'
require 'version'
DB = BlackStack::Core::CRDB::connect
require 'lib/skeleton'

# signup a new account
BlackStack::Core::Account::signup(
    :companyname => 'name of your company', 
    :username => 'your name',
    :email => 'linkedin@expandedventure.com', 
    :password => 'your.password123',
    :phone => '555-5555'
)
