require 'sequel'
require_relative './user'

module BlackStack
  module Core
    class Account < Sequel::Model(:account)
        # always include this line in the model definition
        BlackStack::Core::Account.dataset = BlackStack::Core::Account.dataset.disable_insert_output
 
        # attributes
        one_to_many :users, :class=>:'BlackStack::User', :key=>:id_client
        many_to_one :timezone, :class=>:'BlackStack::Timezone', :key=>:id_timezone
        many_to_one :billingCountry, :class=>:'BlackStack::LnCountry', :key=>:billing_id_lncountry
        many_to_one :user_to_contect, :class=>'BlackStack::User', :key=>:id_user_to_contact

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
        def storage_total_kb
          # TODO: get this parameter from the paid invoces
          1024*1024 # 1 GB
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