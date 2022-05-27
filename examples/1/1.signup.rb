# load blackstack-core gem
require 'lib/core'
require 'lib/account'

# signup a new account
BlackStack::Core::Account::signup('name of your company', 'your name', 'your@email.com', 'your.password')
