require 'sequel'
require_relative './user'

module BlackStack
  module Core
    class Account < Sequel::Model(:account)
        one_to_many :users, :class=>:'BlackStack::Core::User', :key=>:id_account
        many_to_one :timezone, :class=>:'BlackStack::Core::Timezone', :key=>:id_timezone
        many_to_one :user_to_contact, :class=>'BlackStack::Core::User', :key=>:id_user_to_contact
        many_to_one :account_owner, :class=>'BlackStack::Core::Account', :key=>:id_account_owner

        # validate the parameters in the signup descriptor `h``.
        # create new records on tables account, user and login.
        # return the id of the new login record.
        # raise an exception if the signup descriptor doesn't pass all the valdiations.
        def self.signup(h, notif=true)
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

          # notificar al usuario, if the notif flag is true
          # TODO: https://github.com/leandrosardi/mysaas/issues/27
          if notif
            BlackStack::Core::NotificationWelcome.new(u).do
            BlackStack::Core::NotificationConfirm.new(u).do
          end

          # libero recursos
          DB.disconnect
          GC.start

          # retornar el nuevo objeto login
          l
        end # def self.signup(h)

        # signup a new user to this account.
        # return the new user object.
        def add_user(h)
          errors = []

          # validate: h[:email] is required
          if h[:email].to_s.size==0
            errors << "Email is required."
          end

          # validate: h[:email] is valid
          if !h[:email].email?
            errors << "Email is not valid."
          end

          # validate: h[:name] is required
          if h[:name].to_s.size==0
            errors << "Name is required."
          end

          # validate: h[:name] is not longer then 50 chars
          if h[:name].to_s.size>50
            errors << "Name is too long."
          end

          # validate: h[:email] is not already registered
          t = BlackStack::Core::User.where(:email=>h[:email]).first 
          if !t.nil?
            # if the user exists under this account
            if t.id_account.to_guid == self.id.to_guid
              errors << "Email already exists."
            else
              errors << "Email already exists under another account."
            end
          end

          # if there are errors, raise exception with errors
          if errors.size > 0
            raise errors.join("\n")
          end

          # perform operation
          u = BlackStack::Core::User.new
          u.id = guid
          u.id_account = self.id
          u.create_time = now
          u.email = h[:email]
          u.name = h[:name]
          u.phone = h[:phone]
          u.password = BCrypt::Password.create(guid) # generate a random password
          u.save

          # return
          u
        end

        # signup a new user to this account.
        # return the new user object.
        def remove_users(h)
          errors = []

          # validate: h[:ids] is required
          if h[:ids].to_s.size==0
            errors << "Ids is required."
          end

          # TODO: validate: h[:ids] is a list of comma separated guids

          # split ids by comma
          ids = h[:ids].split(",")
          users = []

          # validate: each id is a user belonging to this account
          ids.each do |id|
            t = BlackStack::Core::User.where(:id=>id).first
            if t.nil?
              errors << "User #{id} not found."
            elsif t.id_account.to_guid != self.id.to_guid
              errors << "User #{id} is not belonging to this account."
            else
              users << t
            end
          end

          # if there are errors, raise exception with errors
          if errors.size > 0
            raise errors.join("\n")
          end

          # perform operation
          users.each do |u|
            u.remove
          end

        end

        # return the user to contact for any communication.
        # if the client configured the contact field, this method returns such user.
        # if the client didn't configure the contact field, this method returns first user signed up that is not deleted.
        def contact
          !self.user_to_contact.nil? ? self.user_to_contact : self.users.select { |u| u.delete_time.nil? }.sort_by { |u| u.create_time }.first
        end
        def user_owner
          self.contact
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