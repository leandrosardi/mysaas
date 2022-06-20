module BlackStack
    module CRDB
        # database connection parameters
        @@db_url = nil
        @@db_port = nil
        @@db_name = nil
        @@db_user = nil
        @@db_password = nil

        # return the connection string for a postgresql database
        def self.connection_string
            "postgres://#{@@db_user}:#{@@db_password}@#{@@db_url}:#{@@db_port}/#{@@db_name}"
        end # connection_string

        # create database connection
        def self.connect
            Sequel.connect(BlackStack::CRDB.connection_string)
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
        end # set_db_params

        # return a postgresql uuid
        def self.guid()
            DB['SELECT gen_random_uuid() AS id'].first[:id]
        end
            
        # return current datetime with format `YYYY-MM-DD HH:MM:SS`
        def self.now()
            # La llamada a GETDATE() desde ODBC no retorna precision de milisegundos, que es necesaria para los registros de log.
            # La llamada a SYSDATETIME() retorna un valor de alta precision que no es compatible para pegar en los campos del tipo DATATIME.
            # La linea de abajo obtiene la hora en formato de SYSDATE y le trunca los ultimos digitos para hacer que el valor sea compatible con los campos DATETIME.
            (DB['SELECT current_timestamp() AS now'].map(:now)[0]).to_s[0..18]
        end
    end # module CRDB
end # module BlackStack
