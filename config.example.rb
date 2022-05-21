﻿# Never push the `config.rb` file to the repository.
# Be sure this file is always included in the `.gitignore` file.

# is this a development environment?
# many features below will be enabled or disabled based on this flag
SANDBOX = false # ambiente de desarrollo? => conecta a un SQLEXPRESS

# DB ACCESS TO THE CENTRAL - KEEP IT SECRET
# Remember to enable TCP/IP connections from 'SQL Server Configuration Manager'.
# Remember to set all protocols listining the port 1433 in 'SQL Server Configuration Manager'.
BlackStack::Core::DB::set_db_params({
  :db_url => '%db_url%',
  :db_port => %db_port%,
  :db_name => '%db_name%',
  :db_user => '%db_user%',
  :db_password => '%db_password%',
})

# Setup connection to the API, in order get bots requesting and pushing data to the database.
# TODO: write your API-Key here. Refer to this article about how to create your API key:
# https://sites.google.com/expandedventure.com/knowledge/
BlackStack::Core::API::set_api_url({
  # IMPORTANT: It is strongly recommended that you 
  # use the api_key of an account with prisma role, 
  # and assigned to the central division too.
  :api_key => 'a272972a-121d-4bc2-9413-a9bd7fa983cf', 
  # IMPORTANT: It is stringly recommended that you 
  # write the URL of the central division here. 
  :api_protocol => 'https',
  # IMPORTANT: Even if you are running process in our LAN, 
  # don't write a LAN IP here, since bots are designed to
  # run anywhere worldwide.
  :api_domain => 'connectionsphere.com', 
  :api_port => 443,
})

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
BlackStack::Core::Storage::set_storage({
  :storage_storage_folder => './public/clients',
  :storage_default_max_allowed_kilobytes => 15 * 1024,
  :storage_sub_folders => [
    'downloads', 'uploads', 'logs'
  ],
})

# IMPORTANT NOTE: This value should have a format like FOO.COM. 
# => Other formats can generate bugs in the piece of codes where 
# => this constant is concatenated. 
APP_DOMAIN = "connectionsphere.com" 
APP_NAME = "ConnectionSphere"

# Company Information
COMPANY_NAME = "Expanded Venture"
COMPANY_ADDRESS = "Basualdo 113 (1408), Buenos Aires City, Argentina"
COMPANY_PHONE = "+54 11 4682 4132"
COMPANY_URL = "https://ExpandedVenture.com"

# app url
CS_HOME_PAGE_PROTOCOL = "https"
CS_HOME_PAGE_DOMAIN = "connectionsphere.com"
CS_HOME_PAGE_PORT = "443"
CS_HOME_WEBSITE = "#{CS_HOME_PAGE_PROTOCOL}://#{CS_HOME_PAGE_DOMAIN}:#{CS_HOME_PAGE_PORT}"

# setting up breakpoints for backend processes.
# enabling/disabling the flag `:alloow_brakpoints` will enable/disable the function `binding.pry`
BlackStack::Debugging::set({
  :allow_breakpoints => false,
})

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
    }, {
        :name => "invoicing-payments-processing",
        :access_roles => ['all'],
        :section => nil,
        :version => "1.0.0",
    }],

});

