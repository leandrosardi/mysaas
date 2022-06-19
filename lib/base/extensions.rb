require 'blackstack-deployer'

module BlackStack
    module Extensions
        # array of Extension objects
        @@extensions = []

        # getters and setters
        def self.extensions
            @@extensions
        end

        # If the extension is an app, this module is to define the icons in the leftbar of the extension. 
        module LeftBarIconModule
            # return an arrayn of strings with the errors found on the hash descriptor
            def self.validate_descritor(h)
                errors = []

                # only if h is a hash
                if h.is_a?(Hash)
                    # the key :label must exits
                    errors << ":label is required" if h[:label].to_s.size==0
                    
                    # the value of h[:label] must be a string
                    errors << ":label must be a string" if !h[:label].is_a?(String)

                    # the key :icon must exits
                    errors << ":icon is required" if h[:icon].to_s.size==0

                    # the value of h[:icon] must be a symbol
                    errors << ":icon must be a symbol" if !h[:icon].is_a?(Symbol)

                    # the key :screen must exits
                    errors << ":screen is required" if h[:screen].to_s.size==0

                    # the value of h[:screen] must be a symbol
                    errors << ":screen must be a symbol" if !h[:screen].is_a?(Symbol)
                end
                
                # return
                errors
            end # validate_descritor

            # map a hash descriptor to the attributes of the object
            def initialize(h)
                errors = BlackStack::Extensions::LeftBarIconModule::validate_descritor(h)
                # if there are errors, raise an exception
                raise "Invalid descriptor: #{errors.join(', ')}" if errors.size>0
                # map the parameters
                self.label = h[:label]
                self.icon = h[:icon].to_s
                self.screen = h[:screen].to_s
            end # set

            # get a hash descriptor of the object
            def to_hash
                {
                    :label => self.label,
                    :icon => self.icon.to_sym,
                    :screen => self.screen.to_sym,
                }
            end # to_hash
        end # module LeftBarIconModule

        # If the extension is an app or api, this module is to define the pages to add in the settings screen, for the extension.
        module SettingScreenModule
            # return an array of strings with the errors found on the hash descriptor
            def self.validate_descritor(h)
                errors = []

                # validate: h must be a hash
                errors << "setting_screen must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: the key :section is required
                    errors << ":section is required" if h[:section].to_s.size==0

                    # validate: the value of h[:section] must be a string
                    errors << ":section must be a string" if !h[:section].is_a?(String)

                    # validate: the key :label is required
                    errors << ":label is required" if h[:label].to_s.size==0

                    # validate: the value of h[:label] must be a string
                    errors << ":label must be a string" if !h[:label].is_a?(String)

                    # validate: the key :screen is required
                    errors << ":screen is required" if h[:screen].to_s.size==0

                    # validate: the value of h[:screen] must be a symbol
                    errors << ":screen must be a symbol" if !h[:screen].is_a?(Symbol)
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def initialize(h)
                errors = BlackStack::Extensions::SettingScreenModule::validate_descritor(h)
                # if there are errors, raise an exception
                raise "Invalid descriptor: #{errors.join(', ')}" if errors.size>0
                # map the parameters
                self.section = h[:section]
                self.label = h[:label]
                self.screen = h[:screen].to_s
            end # set

            # get a hash descriptor of the object
            def to_hash
                {
                    :section => self.section,
                    :label => self.label,
                    :screen => self.screen.to_sym,
                }
            end # to_hash
        end # module SettingScreenModule

        # This module is to define the folders to add in the storage, for the extension.
        module StorageFolderModule
            # return an array of strings with the errors found on the hash descriptor
            def self.validate_descritor(h)
                errors = []

                # validate: h must be a hash
                errors << "storage_folder descriptor must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: the key :name is required
                    errors << ":name is required" if h[:name].to_s.size==0

                    # validate: the value of h[:name] must be a string
                    errors << ":name must be a string" if !h[:name].is_a?(String)
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def initialize(h)
                errors = BlackStack::Extensions::StorageFolderModule::validate_descritor(h)
                # if there are errors, raise an exception
                raise "Invalid descriptor: #{errors.join(', ')}" if errors.size>0
                # map the parameters
                self.name = h[:name]
            end # set

            # get a hash descriptor of the object
            def to_hash
                {
                    :name => self.name,
                }
            end # to_hash
        end # module StorageFolderModule

        # This module is to define which other extensions are required for the extension.
        module DependencyModule
            # return an array of strings with the errors found on the hash descriptor
            def self.validate_descritor(h)
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
                errors = BlackStack::Extensions::DependencyModule::validate_descritor(h)
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

        # This module is to define a an extnsion
        module ExtensionModule
            # return an array of strings with the errors found on the hash descriptor
            def self.validate_descritor(h)
                errors = []
binding.pry
                # validate: h must be a hash
                errors << "extension descriptor must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: the key :name is required
                    errors << ":name is required" if h[:name].to_s.size==0

                    # validate: the value of h[:name] must be a string
                    errors << ":name must be a string" if !h[:name].is_a?(String)

                    # validate: the key :description is required
                    errors << ":description is required" if h[:description].to_s.size==0

                    # validate: the value of h[:description] must be a string
                    errors << ":description must be a string" if !h[:description].is_a?(String)

                    # validate: the key :author is required
                    errors << ":author is required" if h[:author].to_s.size==0

                    # validate: the value of h[:author] must be a string
                    errors << ":author must be a string" if !h[:author].is_a?(String)

                    # validate: the key :version is required
                    errors << ":version is required" if h[:version].to_s.size==0

                    # validate: the value of h[:version] must be a string
                    errors << ":version must be a string" if !h[:version].is_a?(String)


                    # if the key :app_section exists, it must be a string
                    if h[:app_section].to_s.size>0
                        errors << ":app_section must be a string" if !h[:app_section].is_a?(String)
                    end

                    # if the key :show_in_top_bar exists, it must be a bool
                    if h[:show_in_top_bar].to_s.size>0
                        errors << ":show_in_top_bar must be a bool" if !h[:show_in_top_bar].is_a?(TrueClass) and !h[:show_in_top_bar].is_a?(FalseClass)
                    end

                    # if the key :show_in_footer exists, it must be a bool
                    if h[:show_in_footer].to_s.size>0
                        errors << ":show_in_footer must be a bool" if !h[:show_in_footer].is_a?(TrueClass) and !h[:show_in_footer].is_a?(FalseClass)
                    end

                    # if the key :show_in_dashboard exists, it must be a bool
                    if h[:show_in_dashboard].to_s.size>0
                        errors << ":show_in_dashboard must be a bool" if !h[:show_in_dashboard].is_a?(TrueClass) and !h[:show_in_dashboard].is_a?(FalseClass)
                    end


                    # if exists the key :dependencies
                    if h[:dependencies].to_s.size>0
                        # validate: the value of h[:dependencies] must be an array
                        errors << ":dependencies must be an array" if !h[:dependencies].is_a?(Array)

                        # validate: each element of h[:dependencies] must be a valid dependency descriptor
                        h[:dependencies].each do |i|
                            e = BlackStack::Extensions::DependencyModule::validate_descritor(i)
                            errors << ":dependencies must be an array of dependency descriptors. Errors found: #{e.join(". ")}" if e.size>0
                        end
                    end # if exists the key :dependencies

                    # if the key :leftbar_icons exists, it must be an array, and each array element must be a valid leftbaricon descriptor
                    if h[:leftbar_icons].to_s.size>0
                        errors << ":leftbar_icons must be an array" if !h[:leftbar_icons].is_a?(Array)
                        h[:leftbar_icons].each do |i|
                            e = BlackStack::Extensions::LeftBarIconModule::validate_descritor(i)
                            errors << ":leftbar_icons must be an array of leftbaricon descriptors. Errors found: #{e.join(". ")}" if e.size>0
                        end
                    end

                    # if the key :setting_screens exists, it must be an array, and each array element must be a valid settingscreen descriptor
                    if h[:setting_screens].to_s.size>0
                        errors << ":setting_screens must be an array" if !h[:setting_screens].is_a?(Array)
                        h[:setting_screens].each do |i|
                            e = BlackStack::Extensions::SettingScreenModule::validate_descritor(i)
                            errors << ":setting_screens must be an array of settingscreen descriptors. Errors found: #{e.join(". ")}" if e.size>0
                        end
                    end

                    # if the key :storage_folders exists, it must be an array, and each array element must be a valid storagefolder descriptor
                    if h[:storage_folders].to_s.size>0
                        errors << ":storage_folders must be an array" if !h[:storage_folders].is_a?(Array)
                        h[:storage_folders].each do |i|
                            e = BlackStack::Extensions::StorageFolderModule::validate_descritor(i)
                            errors << ":storage_folders must be an array of storagefolder descriptors. Errors found: #{e.join(". ")}" if e.size>0
                        end
                    end
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def initialize(h)
                errors = BlackStack::Extensions::ExtensionModule::validate_descritor(h)
        
                # if there are errors, raise an exception
                raise "Errors found: #{errors.join(". ")}" if errors.size>0

                # map the hash descriptor to the attributes of the object
                self.name = h[:name] if h[:name].to_s.size>0
                self.description = h[:description] if h[:description].to_s.size>0
                self.author = h[:author] if h[:author].to_s.size>0
                self.version = h[:version] if h[:version].to_s.size>0

                self.app_section = h[:app_section] if h[:app_section].to_s.size>0
                self.show_in_top_bar = h[:show_in_top_bar] if h[:show_in_top_bar].to_s.size>0
                self.show_in_footer = h[:show_in_footer] if h[:show_in_footer].to_s.size>0
                self.show_in_dashboard = h[:show_in_dashboard] if h[:show_in_dashboard].to_s.size>0

                if h[:dependencies].to_s.size>0
                    h[:dependencies].each do |i|
                        self.dependencies << BlackStack::Extensions::Dependency.new(i) 
                    end
                end

                if h[:leftbar_icons].to_s.size>0
                    h[:leftbar_icons].each do |i|
                        self.leftbar_icons << BlackStack::Extensions::LeftBarIcon.new(i)
                    end
                end

                if h[:setting_screens].to_s.size>0
                    h[:setting_screens].each do |i|
                        self.setting_screens << BlackStack::Extensions::SettingScreen.new(i)
                    end
                end

                if h[:storage_folders].to_s.size>0
                    h[:storage_folders].each do |i|
                        self.storage_folders << BlackStack::Extensions::StorageFolder.new(i)
                    end
                end
            end # set

            # get a hash descriptor of the object
            def to_hash
                h = {}
                
                h[:name] = self.name if self.name.to_s.size>0
                h[:description] = self.description if self.description.to_s.size>0
                h[:author] = self.author if self.author.to_s.size>0
                h[:version] = self.version if self.version.to_s.size>0
                    
                h[:app_section] = self.app_section if self.app_section.to_s.size>0
                h[:show_in_top_bar] = self.show_in_top_bar if self.show_in_top_bar.to_s.size>0
                h[:show_in_footer] = self.show_in_footer if self.show_in_footer.to_s.size>0
                h[:show_in_dashboard] = self.show_in_dashboard if self.show_in_dashboard.to_s.size>0

                if self.dependencies.size>0
                    h[:dependencies] = []
                    self.dependencies.each do |i|
                        h[:dependencies] << i.to_hash
                    end
                end

                if self.leftbar_icons.size>0
                    h[:leftbar_icons] = []
                    self.leftbar_icons.each do |i|
                        h[:leftbar_icons] << i.to_hash
                    end
                end

                if self.setting_screens.size>0
                    h[:setting_screens] = []
                    self.setting_screens.each do |i|
                        h[:setting_screens] << i.to_hash
                    end
                end

                if self.storage_folders.size>0
                    h[:storage_folders] = []
                    self.storage_folders.each do |i|
                        h[:storage_folders] << i.to_hash
                    end
                end

                h
            end # to_hash
        end # module ExtensionModule

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
#puts
#puts
#puts "name: #{name}"
#puts "name.is_a?(Symbol): #{name.is_a?(Symbol)}"
            # validate: name must be a symbol
            raise "name must be a symbol" if !name.is_a?(Symbol)
            # require
            require "extensions/#{name.to_s}/extension"
        end # require
    end # module Extensions
end # module BlackStack
