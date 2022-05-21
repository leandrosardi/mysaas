require 'sequel'

module BlackStack
    module Core
        class User < Sequel::Model(:user)
            # always include this line in the model definition
            BlackStack::Core::User.dataset = BlackStack::Core::User.dataset.disable_insert_output



            # get the value of a configuration parameter for this user
            def get_config(name)
                # TODO: Code Me!
            end

            # set the value of a configuration parameter for this user
            def set_config(name, value)
                # TODO: Code Me!
            end

            # return true if exists a configuration parameter for this user, with the given name
            def config_exists?(name)
                # TODO: Code Me!
            end

        end # class User
    end # module Core
end # module BlackStack