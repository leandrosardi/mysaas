require 'sequel'

module BlackStack
    module Core
        class Login < Sequel::Model(:login)
            # always include this line in the model definition
            BlackStack::Core::Login.dataset = BlackStack::Core::Login.dataset.disable_insert_output

        end # class Login
    end # module Core
end # module BlackStack