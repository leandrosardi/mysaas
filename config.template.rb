# Never push the `config.rb` file to the repository.
# Be sure this file is always included in the `.gitignore` file.

# is this a development environment?
# many features below will be enabled or disabled based on this flag
SANDBOX = true # ambiente de desarrollo? => conecta a un SQLEXPRESS

# this is the timezone assigned to new users, by default.
DEFAULT_TIMEZONE_SHORT_DESCRIPTION = 'Buenos Aires'

# setting up breakpoints for backend processes.
# enabling/disabling the flag `:alloow_brakpoints` will enable/disable the function `binding.pry`
BlackStack::Debugging::set(
  :allow_breakpoints => SANDBOX,
)

# DB ACCESS - KEEP IT SECRET
BlackStack::Core::CRDB::set_db_params(
  :db_url => '@db_url@',
  :db_port => '@db_port@',
  :db_name => '@db_name@',
  :db_user => '@db_user@',
  :db_password => '@db_password@',
)

# Setup connection to the API, in order get bots requesting and pushing data to the database.
# TODO: write your API-Key here. Refer to this article about how to create your API key:
# https://sites.google.com/expandedventure.com/knowledge/
BlackStack::Core::API::set_api_url(
  # IMPORTANT: It is strongly recommended that you 
  # use the api_key of an account with prisma role, 
  # and assigned to the central division too.
  :api_key => '4db9d88c-dee9-4b5a-8d36-134d38e9f763', 
  # IMPORTANT: It is stringly recommended that you 
  # write the URL of the central division here. 
  :api_protocol => 'http',
  # IMPORTANT: Even if you are running process in our LAN, 
  # don't write a LAN IP here, since bots are designed to
  # run anywhere worldwide.
  :api_domain => '127.0.0.1', 
  :api_port => '80',
)

# storage configuration of new accounts
# 
# Every account has assigned a folder where are stored 
# files regarding the different services of the platform. Here you
# can setup the location of the clients' folder, and also the list
# of subfolders to manage for each client.
#
# If you remove a folder from set_storage_sub_folders, it will not 
# be deleted from the filesystem. But if you add a folder to the 
# array set_storage_sub_folders it should be added to every new 
# client automatically. This feature is pending.
# 
# By now, to update the storage forder of an account, you should use
# the method `Account::update_storage_folder`. 
#
BlackStack::Core::Storage::set_storage(
  :storage_folder => './public/clients',
  :storage_default_max_allowed_kilobytes => 15 * 1024,
  :storage_sub_folders => [
    'downloads', 'uploads', 'logs'
  ],
)

# IMPORTANT NOTE: This value should have a format like FOO.COM. 
# => Other formats can generate bugs in the piece of codes where 
# => this constant is concatenated. 
APP_DOMAIN = "127.0.0.1" 
APP_NAME = "@app_name@"

# Company Information
COMPANY_NAME = "@company_name@"
COMPANY_ADDRESS = "@company_address@"
COMPANY_PHONE = "@company_phone@"
COMPANY_URL = "@company_url@"

# app url
CS_HOME_PAGE_PROTOCOL = "http"
CS_HOME_PAGE_DOMAIN = "127.0.0.1"
CS_HOME_PAGE_PORT = "80"
CS_HOME_WEBSITE = "#{CS_HOME_PAGE_PROTOCOL}://#{CS_HOME_PAGE_DOMAIN}:#{CS_HOME_PAGE_PORT}"

=begin
# API access to PostMark
POSTMARK_API_TOKEN = '@postmark_api_token@'

# parameters for email notifications
# how to get Postmark SMTP parameters: https://postmarkapp.com/developer/user-guide/send-email-with-smtp
BlackStack::Core::EmailDeliveryModule.set (
  # smtp request sender information
  :sender_email => '@sender_email@',
  :from_email => '@from_email@', # reply-to field in the SMTP request
  :from_name => '@from_name@',
  
  # smtp request connection information
  :smtp_url => '@smtp_url@',
  :smtp_port => '@smtp_port@',
  :smtp_user => '@smtp_user@',
  :smtp_password => '@smtp_password@',

  # email body configuration
  :logo_url => 'https://connectionsphere.com/core/images/logo/logo-32-01.png',
  :signature_picture_url => 'https://connectionsphere.com/core/images/leandro_sardi.png',
  :signature_name => 'Leandro D. Sardi',
  :signature_position => 'Founder & CEO',
)

# setting up extensions
BlackStack::Extensions.set({
    # locations where extensions are installed for your project
    :extensions_path => 'c:/code',
    # here is the array of extensions that will be loaded
    :extensions => [{
        # this is the name of the folder where the extension is installed
        :name => "pampa",
        # what are the roles assigned to a user who can see this extension
        :access_roles => ['su'],
        # on which products-section show we include this module
        # set it to nil if you don't want to include it any product, but as a core feature of the platform 
        :section => 'Software',
        # what is the version of the module to include
        :version => "1.0.0",
        # the git path from where clone (install) and update the module
        :git_path => 'https://github.com/leandrosardi/pampa' 
    }, {
        :name => "invoicing-payments-processing",
        :access_roles => ['all'],
        :section => nil,
        :version => "1.0.0",
        :git_path => 'https://github.com/leandrosardi/invoicing-payments-processing', 
    }],
});
=end
