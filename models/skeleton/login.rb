require 'sequel'

module BlackStack
    module Core
        class Login < Sequel::Model(:login)
            many_to_one :user, :class=>:'BlackStack::Core::User', :key=>:id_user
        end # class Login
    end # module Core
end # module BlackStack