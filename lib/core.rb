module BlackStack
    module Core
        # database connection parameters
        @@db_url = nil
        @@db_port = nil
        @@db_name = nil
        @@db_user = nil
        @@db_password = nil
        
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
            @@db_url = h[:db_url]
            @@db_port = h[:db_port]
            @@db_name = h[:db_name]
            @@db_user = h[:db_user]
            @@db_password = h[:db_password]
        end

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
            @@api_key = s
        end
        def self.set_api_url(h)
            @@api_key = h[:api_key]
            @@api_protocol = h[:api_protocol]
            @@api_domain = h[:api_domain]
            @@api_port = h[:api_port]
        end

        # accounts storage parameters
        @@storage_folder = nil
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
            @@storage_sub_folders = a
        end
        def self.add_storage_sub_folders(a)
            @@storage_sub_folders += a
        end

    end # module Core
end # module BlackStack