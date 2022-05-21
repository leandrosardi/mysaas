class Account < 
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