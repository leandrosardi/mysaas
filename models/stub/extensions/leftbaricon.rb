require 'blackstack-deployer'

module BlackStack
    module Extensions
        # If the extension is an app, this module is to define the icons in the leftbar of the extension. 
        class LeftBarIcon
            include BlackStack::Extensions::LeftBarIconModule
            attr_accessor :label, :icon, :screen
        end # class LeftBarIcon
    end # module Extensions
end # module BlackStack