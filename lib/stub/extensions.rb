require 'blackstack-deployer'

module BlackStack
    module Extensions
        @@path
        @@dependencies = []
        @@app = {}
        @@setting_screens = []

        module StorageFolderModule
        end # module StorageFoldersModule

        module DependencyModule
        end # module DependencyModule

        module AppModule
        end # module AppModule

        module SettingScreenModule
        end # module SettingScreenModule    

        # setters and getters
        def self.set_path(s)
            @@path = s
        end
        def self.path()
            @@path
        end
        def self.dependencies()
            @@dependencies
        end
        def self.app()
            @@app
        end
        def self.setting_screens()
            @@setting_screens
        end

        # return an array of string with the errors found in the extension descriptor
        def self.validate_descriptor(h)
            errors = []

            # validate: the name is required
            errors << "The name is required" if h['name'].nil?
            # validate: the name is a string
            errors << "The name must be a string" unless h['name'].is_a? String

            # validate: the description is required
            errors << "The description is required" if h['description'].nil?
            # validate: the description is a string
            errors << "The description must be a string" unless h['description'].is_a? String

            # validate: the folder is required
            errors << "The folder is required" if h['folder'].nil?
            # validate: the folder is a valid filename
            errors << "The folder must be a valid filename" unless h['folder'].match(/^[a-zA-Z0-9_\-]+$/) # TODO: mover esta validacion a blackstack-core

            # validate: the version is required
            errors << "The version is required" if h['version'].nil?
            # validate: the version is a version number
            errors << "The version must be a valid version number" unless h['version'].match(/^\d+\.\d+\.\d+$/) # TODO: mover esta validacion a blackstack-core

            # validate the :storage_folders array if it is present
            if h.has_key?('storage_folders')
                errors += BlackStack::Extensions::StorageFolderModule.validate_descriptor(h['storage_folders'])
            end

            # validate the :dependencies array if it is present
            if h.has_key?('dependencies')
                errors += BlackStack::Extensions::DependencyModule.validate_descriptor(h['dependencies'])
            end

            # validate the :app hash if it is present
            if h.has_key?('app')
                errors += BlackStack::Extensions::AppModule.validate_descriptor(h['app'])
            end

            # validate the :setting_screens hash if it is present
            if h.has_key?('setting_screens')
                errors += BlackStack::Extensions::SettingScreenModule.validate_descriptor(h['setting_screens'])
            end            
        end

        def self.appened(name)
        end

        def self.push()
        end

        def self.clone(name)
        end

        def self.pull(name, version)
        end
    end # module Extensions
end # module BlackStack
