# load gem and connect database
require 'lib/core.rb'
require 'config'
require 'version'
DB = BlackStack::Core::CRDB::connect
require 'lib/orm'

u = BlackStack::Core::User.first
puts u.email 