module BlackStack
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
end # module BlackStack
