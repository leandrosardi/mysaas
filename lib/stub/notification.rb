require 'lib/stub/email'

module BlackStack
  module Core
    module NotificationDeliveryModule
      # notifications setup
      @@logo_url = nil
      @@signature_picture_url = nil
      @@signature_name = nil
      @@signature_position = NotificationDeliveryModule
      @@notifications = []

      # getters and setters
      def self.logo_url
        @@logo_url
      end
      def self.signature_picture_url
        @@signature_picture_url
      end
      def self.signature_name
        @@signature_name
      end
      def self.signature_position
        @@signature_position
      end
      def self.set(h)
        errors = []
          
        # validate: h must be a hash
        errors << "h must be a hash" unless h.is_a?(Hash)

        # validate: logo_url is required
        errors << ":logo_url is required" if h[:logo_url].to_s.size==0

        # validate: signature_picture_url is required
        errors << ":signature_picture_url is required" if h[:signature_picture_url].to_s.size==0

        # validate: signature_name is required
        errors << ":signature_name is required" if h[:signature_name].to_s.size==0

        # validate: signature_position is required
        errors << ":signature_position is required" if h[:signature_position].to_s.size==0

        # validate: logo_url is a valid url
        errors << ":logo_url must be a valid url" unless h[:logo_url].url?

        # validate: signature_picture_url is a valid url
        errors << ":signature_picture_url must be a valid url" unless h[:signature_picture_url].url?

        # validate: signature_name is a string
        errors << ":signature_name must be a string" if h[:signature_name].class!=String

        # validate: signature_position is a string
        errors << ":signature_position must be a string" if h[:signature_position].class!=String

        # if errors, raise exception
        raise errors.join(', ') if errors.size>0

        # set values
        @@logo_url = h[:logo_url]
        @@signature_picture_url = h[:signature_picture_url]
        @@signature_name = h[:signature_name]
        @@signature_position = h[:signature_position]
      end
    end # module NotificationDeliveryModule
  end # module Core
end # module BlackStack