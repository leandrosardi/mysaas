require 'controllers/extensions/leftbaricon'
require 'controllers/extensions/dependency'
require 'controllers/extensions/settingscreen'
require 'controllers/extensions/storagefolder'
require 'controllers/extensions/extension'

module BlackStack
    module Extensions
        # array of Extension objects
        @@extensions = []

        # getters and setters
        def self.extensions
            @@extensions
        end

        # Create an extension object.
        # Add it to the array of extensions
        # Return the object
        def self.add(h)
            e = BlackStack::Extensions::Extension::new(h)
            @@extensions << e
            e
        end # set

        # Use this method to add an extension to your SaaS
        # This method do a require of the extension.rb file, where is a call to BlackStack::Extensions.add(h)
        def self.append(name)
            # validate: name must be a symbol
            raise "name must be a symbol" if !name.is_a?(Symbol)
            # require
            require "extensions/#{name.to_s}/extension"
        end # require
    end # module Extensions
end # module BlackStack
