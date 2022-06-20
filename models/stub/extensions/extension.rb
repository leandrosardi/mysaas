require 'blackstack-deployer'

module BlackStack
    module Extensions
        # This module is to define a an extnsion
        class Extension
            include BlackStack::Extensions::ExtensionModule
            attr_accessor :name, :version, :description, :author
            attr_accessor :app_section, :show_in_top_bar, :show_in_footer, :show_in_dashboard
            attr_accessor :dependencies, :leftbar_icons, :setting_screens, :storage_folders
            
            def initialize(h)
                self.dependencies = []
                self.leftbar_icons = []
                self.setting_screens = []
                self.storage_folders = []
                super(h)
            end
        end # module ExtensionModule    
    end # module Extensions
end # module BlackStack