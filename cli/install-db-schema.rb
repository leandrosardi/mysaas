#!/usr/bin/env ruby
require_relative './lib/core'
require_relative './lib/blackstack-deployer' # TODO: convert this into a GEM
require_relative './config.rb'

logger = BlackStack::BaseLogger.new(nil)

logger.log 'Welcome to install-db-schema.rb!'
logger.log "This script will 
\t1. connect the database;
\t2. install the database schema; and
\t3. install the database seed data."

logger.logs 'Connect database...'
DB = BlackStack::Core::DB::connect
logger.done

logger.logs 'Database installation...'
BlackStack::Deployer::db_install(logger, PARSER.value('db_name'), PARSER.value('path'), PARSER.value('size'))
logger.done