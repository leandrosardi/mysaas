#!/usr/bin/env ruby
require_relative './lib/core'
require_relative './config.rb'

logger = BlackStack::BaseLogger.new(nil)

logger.log 'Welcome to install-node.rb!'
logger.log 'This script will 
1. connect server via SSL;
2. install CockroachDB;
3. secure the cluster;
4. start the cluster;
5. initialize the cluster.

For more information, refer to: https://github.com/leandrosardi/free-membership-sites/issues/3#issuecomment-1134714952'

logger.logs 'Connect database...'
DB = BlackStack::Core::DB::connect
logger.done

logger.logs 'Database installation...'
#BlackStack::Deployer::db_install(logger, PARSER.value('db_name'), PARSER.value('path'), PARSER.value('size'))
logger.done