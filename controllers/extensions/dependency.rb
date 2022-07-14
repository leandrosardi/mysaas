module BlackStack
    module Extensions
        # This module is to define which other extensions are required for the extension.
        module DependencyModule
            # return an array of strings with the errors found on the hash descriptor
            def self.validate_descriptor(h)
                errors = []

                # validate: h must be a hash
                errors << "dependency must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: key :extension is required
                    errors << ":extension is required" if h[:extension].to_s.size==0

                    # validate: the value of h[:extension] must be a symbol
                    errors << ":extension must be a symbol" if !h[:extension].is_a?(Symbol)

                    # validate: the key :version is required
                    errors << ":version is required" if h[:version].to_s.size==0

                    # validate: the value of h[:version] must be a string
                    errors << ":version must be a string" if !h[:version].is_a?(String)
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def initialize(h)
                errors = BlackStack::Extensions::DependencyModule::validate_descriptor(h)
                # if there are errors, raise an exception
                raise "Invalid descriptor: #{errors.join(', ')}" if errors.size>0
                # map the parameters
                self.extension = h[:extension].to_s
                self.version = h[:version]
            end # set

            # get a hash descriptor of the object
            def to_hash
                {
                    :extension => self.extension.to_sym,
                    :version => self.version,
                }
            end # to_hash
        end # module DependencyModule
    end # module Extensions
end # module BlackStack