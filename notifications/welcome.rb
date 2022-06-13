module BlackStack
  module Core
    class NotificationWelcome < BlackStack::Core::Notification
      def initialize(i_user)
        super(i_user)
        self.type = 1    
      end
      
      def subject_template
        "Welcome to #{APP_NAME}!"
      end

      def body_template()        
        " 
          <p>Dear #{self.user.name.encode_html}, <br>
          Welcome to <b>#{APP_NAME.encode_html}</b>!</p>
          
          <p>
          <b>Whitelist all emails from #{BlackStack::Core::EmailDeliveryModule::sender_email.encode_html}.</b><br/>
          This is important!
          </p>

          <p>
          Below is the email to access your account:<br/>
          <b>email</b>:#{self.user.email.encode_html}<br/>
          </p> 
        "
      end
    end
  end # module Core
end # module BlackStack