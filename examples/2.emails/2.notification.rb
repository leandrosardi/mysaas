# load gem and connect database
require 'lib/core.rb'
require 'lib/stub.rb'
require 'config'
require 'version'
DB = BlackStack::Core::CRDB::connect
require 'lib/skeleton'

u = BlackStack::Core::User.first
puts u.email 

BlackStack::Core::Notification.new(u).do
