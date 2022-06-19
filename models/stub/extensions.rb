require 'blackstack-deployer'
require 'controllers/extensions.rb'

module BlackStack
    module Extensions

        # If the extension is an app, this module is to define the icons in the leftbar of the extension. 
        class LeftBarIcon
            include BlackStack::Extensions::LeftBarIconModule
            attr_accessor :label, :icon, :screen
        end # class LeftBarIcon

        # If the extension is an app or api, this module is to define the pages to add in the settings screen, for the extension.
        class SettingScreen
            include BlackStack::Extensions::SettingScreenModule
            attr_accessor :section, :label, :screen
        end # class SettingScreen

        # This module is to define the folders to add in the storage, for the extension.
        class StorageFolder
            include BlackStack::Extensions::StorageFolderModule
            attr_accessor :name
        end # class StorageFolder

        # This module is to define which other extensions are required for the extension.
        class Dependency
            include BlackStack::Extensions::DependencyModule
            attr_accessor :extension, :version
        end # class Dependency

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
