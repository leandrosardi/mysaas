require 'sequel'
require_relative './user'

module BlackStack
  module Core
    class Account < Sequel::Model(:account)
        # attributes
        one_to_many :users, :class=>:'BlackStack::Core::User', :key=>:id_client
        many_to_one :timezone, :class=>:'BlackStack::Core::Timezone', :key=>:id_timezone
        many_to_one :billingCountry, :class=>:'BlackStack::LnCountry', :key=>:billing_id_lncountry
        many_to_one :user_to_contect, :class=>'BlackStack::Core::User', :key=>:id_user_to_contact

        # validate the parameters in the signup descriptor `h``.
        # create new records on tables account, user and login.
        # return the id of the new login record.
        # raise an exception if the signup descriptor doesn't pass all the valdiations.
        def self.signup(h)
          errors = []
          companyname = h[:companyname]
          username = h[:username]
          email = h[:email]
          password = h[:password]
          phone = h[:phone]
          a = nil
          u = nil
          l = nil

          # validar que los parametros no esten vacios
          if companyname.to_s.size==0
            errors << "Company Name is required."
          end

          if username.to_s.size==0
            errors << "User Name is required."
          end

          if email.to_s.size==0
            errors << "Email is required."
          end

          if password.to_s.size==0
            errors << "Password is required."
          end

          # validar requisitos de la password
          if !password.password?            
            errors << "Password must have letters and number, and 6 chars as minimum."
          end

          # validar formato del email
          if !email.email?
            errors << "Email is not valid."
          end

          # comparar contra la base de datos
          u = BlackStack::Core::User.where(:email=>email).first

          # decidir si el intento de l es exitoso o no
          if !u.nil?
            errors << "Email already exists."
          end

          # TODO: Validar formato del email

          # TODO: Validar normas de seguridad de la password

          # TODO: Validar formato de la password

          # getting timezone
          t = BlackStack::Core::Timezone.where(:short_description=>DEFAULT_TIMEZONE_SHORT_DESCRIPTION).first
          if t.nil?
            errors << "Default timezone not found."
          end # if t.nil?

          # if there are errors, raise exception with errors
          if errors.size > 0
            # libero recursos
            DB.disconnect	
            GC.start
            raise errors.join("\n") 
          end

          DB.transaction do
            # crear el cliente
            a = BlackStack::Core::Account.new
            a.id = guid
            a.id_account_owner = BlackStack::Core::Account.where(:api_key=>BlackStack::Core::API::api_key).first.id # TODO: getting the right owner when we develop domain aliasing
            a.name = companyname
            a.create_time = now
            a.id_timezone = t.id
            a.storage_total_kb = BlackStack::Core::Storage::storage_default_max_allowed_kilobytes
            a.save
            
            # crear el usuario
            u = BlackStack::Core::User.new
            u.id = guid
            u.id_account = a.id
            u.create_time = guid
            u.email = email
            u.name = username
            u.phone = phone
            u.password = BCrypt::Password.create(password) # reference: https://github.com/bcrypt-ruby/bcrypt-ruby#how-to-use-bcrypt-ruby-in-general
            u.create_time = now
            u.save
            
            # user owner
            a.id_user_to_contact = u.id
            a.save
            
            # registrar el l
            l = BlackStack::Core::Login.new
            l.id = guid
            l.id_user = u.id
            l.create_time = now
            l.save
          end # transaction

          # libero recursos
          DB.disconnect
          GC.start

          # retornar el id del login
          l.id
        end # def self.signup(h)

        # return the user to contact for any communication.
        # if the client configured the user_to_contact field, this method returns such user.
        # if the client didn't configure the user_to_contact field, this method returns first user signed up that is not deleted.
        def contact()
          !self.user_to_contect.nil? ? self.user_to_contect : self.users.select { |u| u.delete_time.nil? }.sort_by { |u| u.create_time }.first
        end
        
        # return true if the self.delete_time.nil? == false
        def deleted?
          !self.delete_time.nil?
        end # deleted?

        # retorna un array de objectos UserRole, asignados a todos los usuarios de este cliente
        def user_roles
          a = []
          self.users.each { |o| 
            a.concat o.user_roles 
            # libero recursos
            GC.start
            DB.disconnect
          }
          a    
        end

        # retorna los roles assignados a los usuarios de esta cuenta.
        def roles
          a = []
          self.user_roles.each { |o| a << o.role }
          a.uniq
        end

        # return the location of the storage for this client
        def storage_folder
          "#{BlackStack::Code::Storage::storage_folder}/#{self.id.to_guid}"
        end
        
        def storage_sub_folder(name)
          "#{BlackStack::Code::Storage::storage_folder}/#{self.id.to_guid}/#{name}"
        end
                
        # returns the max allowed KB in the storage for this client
        # TODO: make it both: linux and windows compatible - issue #12
        def storage_used_kb
          path = self.storage_folder
          fso = WIN32OLE.new('Scripting.FileSystemObject')
          folder = fso.GetFolder(path)
          (folder.size.to_f / 1024.to_f) 
        end
        
        # returns the free available KB in the storage for this client
        def storage_free_kb
          total = self.storage_total_kb
          used = self.storage_used_kb
          total - used
        end
          
        # si el cliente no tiene creado el storage, entonces se lo crea, carpeta por carpeta, ferificando cada una si no existe ya.
        def create_storage
          folder = self.storage_folder
          Dir.mkdir BlackStack::Pampa::storage_folder if Dir[BlackStack::Pampa::storage_folder].size==0
          Dir.mkdir folder if Dir[folder].size==0        
          BlackStack::Pampa::storage_sub_folders.each { |name|
            s = "#{folder}/#{name}"
            Dir.mkdir s if Dir[s].size==0        
          }
        end
    end # class Accounts
  end # module Core
end # module BlackStack