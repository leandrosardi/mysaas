# Notification to deliver when a new user signups, and his/her account is created.
module BlackStack
  module MySaaS
    class NotificationWelcome < BlackStack::MySaaS::Notification
      def initialize(i_user)
        super(i_user)
        self.type = 1
      end
      
      def subject_template
        "Welcome to #{APP_NAME}!"
      end

      def body_template()        
        " 
          <p>Dear #{self.user.name.encode_html},</p>

          Welcome to <b>#{APP_NAME.encode_html}</b>!</p>          
          
          <p>
          <b>Whitelist all emails from #{BlackStack::Emails::sender_email.encode_html}.</b><br/>
          This is important!
          </p>

          <p>
          Below is the email to access your account:<br/>
          <b>email</b>:#{self.user.email.encode_html}<br/>
          </p> 
        "
      end
    end # class NotificationWelcome
  end # module MySaaS
end # module BlackStack