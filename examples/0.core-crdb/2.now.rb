require 'pg'
require 'sequel'
require 'lib/core'
require 'config.rb'

DB = BlackStack::Core::CRDB::connect

p now