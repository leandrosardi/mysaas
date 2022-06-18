require 'blackstack-deployer'

module BlackStack
    module Extensions
        # array of Extension objects
        @@extensions = []

        # If the extension is an app, this module is to define the icons in the leftbar of the extension. 
        module LeftBarIconModule
            # return an array of strings with the errors found on the hash descriptor
            def self.validate_descritor(h)
                errors = []

                # only if h is a hash
                if h.is_a?(Hash)
                    # the key :label must exits
                    errors << ":label is required" if h[:label].to_s.size==0
                    
                    # the value of h[:label] must be a string
                    errors << ":label must be a string" if h[:label].class!=String

                    # the key :icon must exits
                    errors << ":icon is required" if h[:icon].to_s.size==0

                    # the value of h[:icon] must be a symbol
                    errors << ":icon must be a symbol" if h[:icon].class!=Symbol

                    # the key :screen must exits
                    errors << ":screen is required" if h[:screen].to_s.size==0

                    # the value of h[:screen] must be a symbol
                    errors << ":screen must be a symbol" if h[:screen].class!=Symbol
                end
                
                # return
                errors
            end # validate_descritor

            # map a hash descriptor to the attributes of the object
            def set(h)
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
                errors << "h must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: the key :section is required
                    errors << ":section is required" if h[:section].to_s.size==0

                    # validate: the value of h[:section] must be a string
                    errors << ":section must be a string" if h[:section].class!=String

                    # validate: the key :label is required
                    errors << ":label is required" if h[:label].to_s.size==0

                    # validate: the value of h[:label] must be a string
                    errors << ":label must be a string" if h[:label].class!=String

                    # validate: the key :screen is required
                    errors << ":screen is required" if h[:screen].to_s.size==0

                    # validate: the value of h[:screen] must be a symbol
                    errors << ":screen must be a symbol" if h[:screen].class!=Symbol
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def set(h)
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
                errors << "h must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: the key :name is required
                    errors << ":name is required" if h[:name].to_s.size==0

                    # validate: the value of h[:name] must be a string
                    errors << ":name must be a string" if h[:name].class!=String
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def set(h)
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
                errors << "h must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: key :extension is required
                    errors << ":extension is required" if h[:extension].to_s.size==0

                    # validate: the value of h[:extension] must be a symbol
                    errors << ":extension must be a symbol" if h[:extension].class!=Symbol

                    # validate: the key :version is required
                    errors << ":version is required" if h[:version].to_s.size==0

                    # validate: the value of h[:version] must be a string
                    errors << ":version must be a string" if h[:version].class!=String
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def set(h)
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

                # validate: h must be a hash
                errors << "h must be a hash" unless h.is_a?(Hash)

                # only if h is a hash
                if h.is_a?(Hash)
                    # validate: the key :name is required
                    errors << ":name is required" if h[:name].to_s.size==0

                    # validate: the value of h[:name] must be a string
                    errors << ":name must be a string" if h[:name].class!=String

                    # validate: the key :description is required
                    errors << ":description is required" if h[:description].to_s.size==0

                    # validate: the value of h[:description] must be a string
                    errors << ":description must be a string" if h[:description].class!=String

                    # validate: the key :author is required
                    errors << ":author is required" if h[:author].to_s.size==0

                    # validate: the value of h[:author] must be a string
                    errors << ":author must be a string" if h[:author].class!=String

                    # validate: the key :version is required
                    errors << ":version is required" if h[:version].to_s.size==0

                    # validate: the value of h[:version] must be a string
                    errors << ":version must be a string" if h[:version].class!=String

                    # if exists the key :dependencies
                    if h[:dependencies].to_s.size>0
                        # validate: the value of h[:dependencies] must be an array
                        errors << ":dependencies must be an array" if h[:dependencies].class!=Array

                        # validate: each element of h[:dependencies] must be a valid dependency descriptor
                        h[:dependencies].each do |i|
                            e = BlackStack::Extensions::DependencyModule::validate_descritor(i)
                            errors << ":dependencies must be an array of dependency descriptors. Errors found: #{e.join(". ")}" if e.size>0
                        end
                    end # if exists the key :dependencies

                    # if the key :app_section exists, it must be a string
                    if h[:app_section].to_s.size>0
                        errors << ":app_section must be a string" if h[:app_section].class!=String
                    end

                    # if the key :show_in_top_bar exists, it must be a bool
                    if h[:show_in_top_bar].to_s.size>0
                        errors << ":show_in_top_bar must be a bool" if h[:show_in_top_bar].class!=TrueClass and h[:show_in_top_bar].class!=FalseClass
                    end

                    # if the key :show_in_footer exists, it must be a bool
                    if h[:show_in_footer].to_s.size>0
                        errors << ":show_in_footer must be a bool" if h[:show_in_footer].class!=TrueClass and h[:show_in_footer].class!=FalseClass
                    end

                    # if the key :show_in_dashboard exists, it must be a bool
                    if h[:show_in_dashboard].to_s.size>0
                        errors << ":show_in_dashboard must be a bool" if h[:show_in_dashboard].class!=TrueClass and h[:show_in_dashboard].class!=FalseClass
                    end

                    # if the key :leftbar_icons exists, it must be an array, and each array element must be a valid leftbaricon descriptor
                    if h[:leftbar_icons].to_s.size>0
                        errors << ":leftbar_icons must be an array" if h[:leftbar_icons].class!=Array
                        h[:leftbar_icons].each do |i|
                            e = BlackStack::Extensions::LeftBarIconModule::validate_descritor(i)
                            errors << ":leftbar_icons must be an array of leftbaricon descriptors. Errors found: #{e.join(". ")}" if e.size>0
                        end
                    end
                end

                # if the key :setting_screens exists, it must be an array, and each array element must be a valid settingscreen descriptor
                if h[:setting_screens].to_s.size>0
                    errors << ":setting_screens must be an array" if h[:setting_screens].class!=Array
                    h[:setting_screens].each do |i|
                        e = BlackStack::Extensions::SettingScreenModule::validate_descritor(i)
                        errors << ":setting_screens must be an array of settingscreen descriptors. Errors found: #{e.join(". ")}" if e.size>0
                    end
                end

                # if the key :storage_folders exists, it must be an array, and each array element must be a valid storagefolder descriptor
                if h[:storage_folders].to_s.size>0
                    errors << ":storage_folders must be an array" if h[:storage_folders].class!=Array
                    h[:storage_folders].each do |i|
                        e = BlackStack::Extensions::StorageFolderModule::validate_descritor(i)
                        errors << ":storage_folders must be an array of storagefolder descriptors. Errors found: #{e.join(". ")}" if e.size>0
                    end
                end

                # return
                errors
            end

            # map a hash descriptor to the attributes of the object
            def set(h)
                errors = BlackStack::Extensions::ExtensionModule::validate_descritor(h)

            end # set

            # get a hash descriptor of the object
            def to_hash
            end # to_hash
        end # module ExtensionModule

        # Define the extension
        def self.add(h)
        end # set

        # Add an extension to your SaaS
        def self.require(name)
        end # require

    end # module Extensions
end # module BlackStack
