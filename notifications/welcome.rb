# Notification to deliver when a new user signups, and his/her account is created.
module BlackStack
  module MySaaS
    class NotificationWelcome < BlackStack::MySaaS::Notification
      def initialize(i_user)
        super(i_user)
        self.type = 1
      end
      
      def subject_template
        "Welcome to #{APP_NAME}! - 2 Bonuses for You!"
      end

      def body_template()        
        " 
          <p>Dear #{self.user.name.encode_html},</p>

          Welcome to <b>#{APP_NAME.encode_html}</b>!</p>          

          <p>Thank you so much for joining us!</p>

          <p>I am very excited to have you on board. I am always looking for new members to join our marketplace of B2B Leads Data.</p>

          <p>As a way to say 'Thank You', I have 2 special bonuses for You!</p>

          <p><b>Bonus #1: Free Leads Data.</b></p>

          <p>
          Every single month you will receive 50 free leads.<br/>
          Really! It's Free!<br/>
          Just go here to get started: <a href='#{CS_HOME_WEBSITE}/leads/results'>#{CS_HOME_WEBSITE}/leads/results</a>
          </p>

          <p><b>Bonus #2: 90% OFF Our Premium Plan.</b></p>

          <p>
          You can upgrade to our Robin plan and get it 90% OFF the first month.<br/>
          Just go here to grab the offer: <a href='#{CS_HOME_WEBSITE}/leads/offer'>#{CS_HOME_WEBSITE}/leads/offer</a><br/>
          <i>(Hurry Up! It is for limited time only!)</i>
          </p>

          <p><b>Also,</b></p>

          <p>
          <b>Whitelist all emails from #{BlackStack::Emails::sender_email.encode_html}.</b><br/>
          This is important!
          </p>

          <p>
          Below is the email to access your account:<br/>
          <b>email</b>: #{self.user.email.encode_html}<br/>
          </p> 
        "
      end
    end # class NotificationWelcome
  end # module MySaaS
end # module BlackStack