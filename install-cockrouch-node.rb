#!/usr/bin/env ruby
require_relative './lib/core'
require_relative './config.rb'

logger = BlackStack::BaseLogger.new(nil)

logger.log 'Welcome to install-node.rb!'
logger.log 'This script will 
1. install Ruby 3.1.2;
2. install CockroachDB;
3. install necessary gems;
4. connect the database;
5. install the database schema;
6. install the database seed data; and 
7. setup the configuration file.'

logger.logs 'Connect database...'
DB = BlackStack::Core::DB::connect
logger.done

logger.logs 'Database installation...'
#BlackStack::Deployer::db_install(logger, PARSER.value('db_name'), PARSER.value('path'), PARSER.value('size'))
logger.done