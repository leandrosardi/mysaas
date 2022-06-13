require 'sequel'

module BlackStack
    module Core
        class User < Sequel::Model(:user)
            many_to_one :account, :class=>:'BlackStack::Core::Account', :key=>:id_account

            def self.login(h)
                errors = []
                email = h[:email]
                password = h[:password]
      
                if email.to_s.size==0
                    errors << "Email is required."
                end
        
                if password.to_s.size==0
                    errors << "Password is required."
                end
                
                # comparar contra la base de datos
                # TODO: getting the right owner when we develop domain aliasing
                u = BlackStack::Core::User.where(:email=>email).first 
        
                # decidir si el intento de l es exitoso o no
                if u.nil?
                    errors << "Email not found."
                end

                # reference: https://github.com/bcrypt-ruby/bcrypt-ruby#how-to-use-bcrypt-ruby-in-general
                if BCrypt::Password.new(u.password) != password
                    # TODO: register failed login attempt
                    # TODO: validate number of login attempts last hour
                    errors << "Wrong passsword."
                end

                # if there are errors, raise exception with errors
                if errors.size > 0
                    # libero recursos
                    DB.disconnect	
                    GC.start
                    raise errors.join("\n") 
                end
                
                # registro el login
                l = BlackStack::Core::Login.new
                l.id = guid
                l.id_user = u.id
                l.create_time = now
                l.save

                # libero recursos
                DB.disconnect
                GC.start

                # return the new login object
                l
            end # def login

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