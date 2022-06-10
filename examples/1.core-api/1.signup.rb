# load gem and connect database
require 'lib/core.rb'
require 'config'
require 'version'
DB = BlackStack::Core::CRDB::connect
require 'lib/orm'
# signup a new account
BlackStack::Core::Account::signup(
    :companyname => 'name of your company', 
    :username => 'your name',
    :email => 'your@email.com', 
    :password => 'your.password123',
    :phone => '555-5555'
)
