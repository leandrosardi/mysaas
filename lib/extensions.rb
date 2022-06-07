require 'blackstack-deployer'

module BlackStack
    @@path
  
    # setters and getters
    def self.set_path(s)
        @@path = s
    end
    def path()
        @@path
    end

    # return an array of string with the errors found in the extension descriptor
    def self.validate_descriptor(h)
        
    end

    def self.appened(:helpdesk)
    end

    def self.push()
    end

    def self.clone(name)
    end

    def self.pull(name, version)
    end
end # module BlackStack
