require 'sequel'

module BlackStack
    module MySaaS
        class Login < Sequel::Model(:login)
            many_to_one :user, :class=>:'BlackStack::MySaaS::User', :key=>:id_user
        end # class Login
    end # module MySaaS
end # module BlackStack