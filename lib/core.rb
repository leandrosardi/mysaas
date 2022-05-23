require 'blackstack_commons'
require 'simple_command_line_parser'
require 'simple_cloud_logging'
require 'pg'
require 'sequel'

module BlackStack
    module Core

        module DB
            # database connection parameters
            @@db_url = nil
            @@db_port = nil
            @@db_name = nil
            @@db_user = nil
            @@db_password = nil

            # create database connection
            def self.connect
                s = "postgres://#{@@db_user}:#{@@db_password}@#{@@db_url}:#{@@db_port}/#{@@db_name}"
                Sequel.connect(s)
            end

            # database connection getters
            def self.db_url
                @@db_url
            end
            def self.db_port
                @@db_port
            end
            def self.db_name
                @@db_name
            end
            def self.db_user
                @@db_user
            end
            def self.db_password
                @@db_password
            end
            def self.set_db_params(h)
                # validate: the parameter h is requred
                raise "The parameter h is required." if h.nil?

                # validate: the parameter h must be a hash
                raise "The parameter h must be a hash" unless h.is_a?(Hash)

                # validate: the :db_url key is required
                raise 'The key :db_url is required' unless h.has_key?(:db_url)

                # validate: the :db_port key is required
                raise 'The key :db_port is required' unless h.has_key?(:db_port)

                # validate: the db_name key is required
                raise 'The key :db_name is required' unless h.has_key?(:db_name)

                # validate: the db_user key is required
                raise 'The key :db_user is required' unless h.has_key?(:db_user)

                # validate: the db_password key is required
                raise 'The key :db_password is required' unless h.has_key?(:db_password)

                # validate: the :db_url key must be a string
                raise 'The key :db_url must be a string' unless h[:db_url].is_a?(String)

                # validate: the :db_port key must be an integer, or a string that can be converted to an integer
                raise 'The key :db_port must be an integer' unless h[:db_port].is_a?(Integer) || (h[:db_port].is_a?(String) && h[:db_port].to_i.to_s == h[:db_port])

                # validate: the :db_name key must be a string
                raise 'The key :db_name must be a string' unless h[:db_name].is_a?(String)

                # validate: the :db_user key must be a string
                raise 'The key :db_user must be a string' unless h[:db_user].is_a?(String)

                # validate: the :db_password key must be a string
                raise 'The key :db_password must be a string' unless h[:db_password].is_a?(String)

                # map values
                @@db_url = h[:db_url]
                @@db_port = h[:db_port].to_i
                @@db_name = h[:db_name]
                @@db_user = h[:db_user]
                @@db_password = h[:db_password]
            end
        end # module DB

        module API
            # API connection parameters
            @@api_key = nil # Api-key of the client who will be the owner of a process.
            @@api_protocol = nil # Protocol, HTTP or HTTPS, of the BlackStack server where this process will be registered.
            @@api_domain = nil # Domain of the BlackStack server where this process will be registered.
            @@api_port = nil # Port of the BlackStack server where this process will be registered.

            # API connection getters and setters
            def self.api_key()
                @@api_key 
            end
            def self.api_protocol
                @@api_protocol
            end 
            def self.api_domain
                @@api_domain
            end
            def self.api_port
                @@api_port
            end
            def self.api_url()
                "#{BlackStack::Pampa::api_protocol}://#{BlackStack::Pampa::api_domain}:#{BlackStack::Pampa::api_port}"
            end
            def self.set_api_key(s)
                # validate: the parameter s is required
                raise 'The parameter s is required' unless s

                # validate: the parameter s must be a string
                raise 'The parameter s must be a string' unless s.is_a?(String)

                # map values
                @@api_key = s
            end
            def self.set_api_url(h)
                # validate: the parameter h is requred
                raise "The parameter h is required." if h.nil?

                # validate: the parameter h must be a hash
                raise "The parameter h must be a hash" unless h.is_a?(Hash)

                # validate: the :api_key key is required
                raise 'The key :api_key is required' unless h.has_key?(:api_key)

                # validate: the :api_protocol key is required
                raise 'The key :api_protocol is required' unless h.has_key?(:api_domain)

                # validate: the :api_domain key is required
                raise 'The key :api_domain is required' unless h.has_key?(:api_domain)

                # validate: the :api_port key is required
                raise 'The key :api_port is required' unless h.has_key?(:api_port)

                # validate: the :api_key key is a string
                raise 'The key :api_key must be a string' unless h[:api_key].is_a?(String)

                # validate: the :api_protocol key is a string
                raise 'The key :api_protocol must be a string' unless h[:api_protocol].is_a?(String)

                # validate: the :api_domain key is a string
                raise 'The key :api_domain must be a string' unless h[:api_domain].is_a?(String)    

                # validate: the :api_port key is an integer, or a string that can be converted to an integer
                raise 'The key :api_port must be an integer' unless h[:api_port].is_a?(Integer) || (h[:api_port].is_a?(String) && h[:api_port].to_i.to_s == h[:api_port])

                # map the values
                @@api_key = h[:api_key]
                @@api_protocol = h[:api_protocol]
                @@api_domain = h[:api_domain]
                @@api_port = h[:api_port].to_i
            end
        end # module API

        module Storage
            # accounts storage parameters
            @@storage_folder = './public/clients'
            @@storage_default_max_allowed_kilobytes = 15*1024 # 15MB
            @@storage_sub_folders = []

            # accounts storage getters and setters
            def self.storage_folder()
                @@storage_folder
            end
            def self.storage_sub_folders()
                @@storage_sub_folders
            end    
            def self.set_storage_folder(path)
                @@storage_folder = path
            end
            def self.set_storage_sub_folders(a)
                # validate: the parameter a must be be an array of strings
                raise 'The parameter a must be an array of strings' if a.class != Array || a.any? { |e| e.class != String }
                @@storage_sub_folders = a
            end
            def self.add_storage_sub_folders(a)
                # validate: the parameter a must be be an array of strings
                raise 'The parameter a must be an array of strings' if a.class != Array || a.any? { |e| e.class != String }
                @@storage_sub_folders += a
            end
            def self.set_storage(h)
                # validate: the parameter h is requred
                raise "The parameter h is required." if h.nil?

                # validate: the parameter h must be a hash
                raise "The parameter h must be a hash" unless h.is_a?(Hash)

                # validate: the :storage_folder key exists
                raise 'The :storage_folder key is required' if h[:storage_folder].nil?

                # validate: the :storage_default_max_allowed_kilobytes key exists
                raise 'The :storage_default_max_allowed_kilobytes key is required' if h[:storage_default_max_allowed_kilobytes].nil?

                # validate: the :storage_sub_folders key exists
                raise 'The :storage_sub_folders key is required' if h[:storage_sub_folders].nil?

                # validate: the :storage_folder key is a string
                raise 'The :storage_folder key must be a string' if h[:storage_folder].class != String

                # validate: the :storage_max_allowed_kilobytes key is an integer, and is greater than 0
                raise 'The :storage_default_max_allowed_kilobytes key must be an integer, and greater than 0' if h[:storage_default_max_allowed_kilobytes].class != Fixnum || h[:storage_default_max_allowed_kilobytes] <= 0

                # validate: the :storage_sub_folders key is an array of strings
                raise 'The :storage_sub_folders key must be an array of strings' if h[:storage_sub_folders].class != Array || h[:storage_sub_folders].any? { |e| e.class != String }

                # map all the parameters
                @@storage_folder = h[:storage_folder]
                @@default_max_allowed_kilobytes = h[:storage_max_allowed_kilobytes]
                @@storage_sub_folders = h[:storage_sub_folders]
            end
        end # module Storage

    end # module Core
end # module BlackStack