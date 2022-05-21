require 'sequel'

module BlackStack
    module Core
        class User < Sequel::Model(:user)
            # always include this line in the model definition
            BlackStack::Core::User.dataset = BlackStack::Core::User.dataset.disable_insert_output

            # get the value of a preference parameter for this user
            def get_preference(name)
                # TODO: Code Me!
            end

            # set the value of a preference parameter for this user
            def set_preference(name, value)
                # TODO: Code Me!
            end

            # return true if exists a preference parameter for this user, with the given name
            def preference_exists?(name)
                # TODO: Code Me!
            end
        end # class User
    end # module Core
end # module BlackStack