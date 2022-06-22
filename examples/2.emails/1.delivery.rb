# load gem and connect database
require 'mail'
require 'lib/core'
require 'lib/stub'
require 'config'
require 'version'

BlackStack::Core::EmailDeliveryModule::delivery(
    :receiver_name => 'Leandro D. Sardi',
    :receiver_email => 'leandro.sardi@expandedventure.com',
    :subject => 'Welcome to ConnectionSphere',
    :body => '<h1>Welcome to ConnectionSphere</h1>',
)