require 'pg'
require 'sequel'
require 'lib/core'
require 'lib/stub'
require 'config.rb'

DB = BlackStack::Core::CRDB::connect

p now