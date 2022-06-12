
class NotificationWelcome < Notification
  NotificationWelcome.dataset = NotificationWelcome.dataset.disable_insert_output

  def initialize()
    super
    self.type = Notification::NOTIFICATION_WELCOME    
  end
  
  def send()
    app_url = self.user.client.division.app_url
    app_port = self.user.client.division.app_port
    wizard_url = "#{CS_HOME_PAGE_PROTOCOL}://#{app_url}:#{app_port}/prospecting/pipeline/new/step1"
    offer_url = "#{CS_HOME_WEBSITE}/prospecting/pipeline/new/welcome"
    reset_url = "#{CS_HOME_WEBSITE}/forgot"

    ssm_url = "#{CS_HOME_WEBSITE}/prospecting/pipeline/new/welcome"
    #fld_url = "#{CS_HOME_PAGE_PROTOCOL}://freeleadsdata.com" # TODO: parametrizar esto
    #ipj_url = "#{CS_HOME_PAGE_PROTOCOL}://invitepeopletojoin.com" # TODO: parametrizar esto
    
    sContent = 
      "<p><b>Congratulations, you just made a VERY wise decision.</b><br>" +
      "The <b>#{APP_NAME}</b> program that we're launching (and you now have access to) is very, VERY powerful.</p>" +
      
      "<p>In fact, We deployed this service privately for our clients in several businesses in several different industries and it worked AMAZINGLY! " +
      "There is ZERO reason it can't do the same for you.</p>" + 

      "<p>" +
      "<b>Whitelist all emails from #{NOTIFICATIONS[:sender_email]}.</b><br/>" +
      "This is important! Not only will you receive our best sales strategies, you’ll also receive your leads here!" +
      "</p>" +

      "<p>" +
      "Below is the email to access your account:<br/>" +
      "<b>email</b>:#{self.user.email}<br/>" +
      "</p>" + 

      "<p>" +
      "If you don't remember your password, you can reset it <a href='#{reset_url}'><b>here</b></a>." +
      "</p>" + 

      "<p>" +
      "Take a few minutes to login at <a href='#{CS_LOGIN_PAGE}'><b>#{APP_NAME}</b></a> (our user dashboard) and check out this. We have really great stuff!" +
      "</p>" + 

      "<p>If you didn't complete our <a href='#{wizard_url}'><b>3-step wizard</b></a> yet, go <a href='#{wizard_url}'><b>here</b></a> now. It's very simple, and you will get your selling campaign ready in 5 minutes or less.</p>" + 

      "<p>If you are still running free, maybe you should consider our <a href='#{offer_url}' target='_window'><b>15-day trial for $1</b></a>. This is a limited time offer, and it can be closed at any moment.<p/>"
      
    sBody = NOTIFICATION_BODY_TEMPLATE.gsub(NOTIFICATION_CONTENT_MERGE_TAG, sContent) 

    if (self.delivery_time != nil)
      raise "This notification has been already delivered."
    end
    self.subject = "[IMPORTANT] Next Steps..."
    self.body = sBody
    self.smtp()
    self.delivery_time = now()
    self.save()
  end
end


class NotificationWelcomeToFreeLeadsData < NotificationWelcome  
  NotificationWelcomeToFreeLeadsData.dataset = NotificationWelcomeToFreeLeadsData.dataset.disable_insert_output

  def initialize()
    super
    self.type = Notification::NOTIFICATION_WELCOME_FREELEADSDATA
  end
  
  def send()
    id_user = self.id_user
    row = DB["SELECT email, password FROM [user] WHERE [id]='#{id_user}'"].first
    email = row[:email]
    password = row[:password]
    sContent = 
      "<p><b>Congratulations, you just made a VERY wise decision.</b><br>" +
      "The <b>FreeLeadsData</b> service that we're launching (and you now have access to) is very, VERY powerful.</p>" +
      
      "<p>In fact, We deployed this service privately for our clients in several businesses in several different industries and it worked AMAZINGLY! " +
      "There is ZERO reason it can't do the same for you.</p>" + 

      "<p>Below are your email and password to access your account:<br/>" +
      "<b>email</b>:#{email}<br/>" +
      "<b>password</b>:#{password}</p>" +

      "<p>If you have joined one of our paid plans, go to <a href='#{CS_LOGIN_PAGE}'>#{APP_NAME}</a> (our user dashboard) and start building high targeted lists of prospects, targeting by <b>6 different filters</b> (job position, country, city, industry, gender and social keywords) and collecting <b>6 different fields of data</b> (email, phone number, fax, street address, company revenue and number of employees).</p>" +
      "<p>As soon as we have the first results you will receive a notification in your inbox.<br/>Stay Tuned!</p>" +

      "<p>If you are still running free, maybe you should consider our <a href='http://freeleadsdata.com/freeleads/tripwire' target='_window'><b>90% off for life</b></a>. This is a limited time offer, and it can be closed at any moment.<p/>" +
      
      "<p>If you want to continue with the <b>free plan</b>, that's ok. Take your time to think about this.<br/>Just spend 1 minute of your time to visit our <a href='http://freeleadsdata.com/freeleads/landing?share=1' target='_window'><b>landing page</b></a> and share it in your social networks. Thanks!</p>"

    sBody = NOTIFICATION_BODY_TEMPLATE.gsub(NOTIFICATION_CONTENT_MERGE_TAG, sContent) 

    if (self.delivery_time != nil)
      raise "This notification has been already delivered."
    end
    self.subject = "Welcome to FreeLeadsData"
    self.body = sBody
    self.smtp()
    self.delivery_time = now()
    self.save()
  end
end


class NotificationWelcomeToPaidLeadsData < NotificationWelcome  
  NotificationWelcomeToFreeLeadsData.dataset = NotificationWelcomeToFreeLeadsData.dataset.disable_insert_output

  def initialize()
    super
    self.type = Notification::NOTIFICATION_WELCOME_FREELEADSDATA
  end
  
  def send()
    id_user = self.id_user
    row = DB["SELECT email, password FROM [user] WHERE [id]='#{id_user}'"].first
    email = row[:email]
    password = row[:password]
    sContent = 
      "<p><b>Congratulations, you are going to start reaching leads like a PRO!</b><br>" +
      "The <b>FreeLeadsData</b> premium service allows you to</p>" +
      "<p>" +
      "* target by 6 different filters,<br/> " +
      "* get 6 different data fields, and<br/> " +
      "* create different searches to manage different segments. " +
      "</p>" +
      
      "<br/><b>Access Information</b><br/>" +
      "<p>Below are your email and password to access your account:<br/>" +
      "<b>email</b>:#{email}<br/>" +
      "<b>password</b>:#{password}</p>" +

      "<br/><b>Searches Creation</b><br/>" +
      "<p>Go to <a href='#{CS_LOGIN_PAGE}'>#{APP_NAME}</a> (our user dashboard) and start building high targeted lists of prospects, targeting by <b>6 different filters</b> (job position, country, city, industry, gender and social keywords) and collecting <b>6 different fields of data</b> (email, phone number, fax, street address, company revenue and number of employees).</p>" +
      "<p>As soon as we have the first results you will receive a notification in your inbox.<br/>Stay Tuned!</p>" +

      "<br/><b>Payment Processing</b><br/>" +
      "<p>Your payment requires validation, and it will processed within the next 24-hours.<br/>But feel free to login to your account and start crating your searches.<p/>" +
      
      "<br/><b>Help</b><br/>" +      
      "<p>Please read this <a href='http://freeleadsdata.com/freeleads/welcome' target='_window'><b>this article</b></a> to get startd, or contact our support team at <a mailto='#{HELPDESK_EMAIL}'><b>#{HELPDESK_EMAIL}</b></a></p>" +

      "<br/><b>Special Offers</b><br/>" +      
      "<p>If you need a large list of leads, you should consider our <a href='http://freeleadsdata.com/freeleads/plans' target='_window'><b>premium plans</b></a> with a risk-free <b>15-day trial</b> for just $1.</p>"

    sBody = NOTIFICATION_BODY_TEMPLATE.gsub(NOTIFICATION_CONTENT_MERGE_TAG, sContent) 

    if (self.delivery_time != nil)
      raise "This notification has been already delivered."
    end
    self.subject = "[Free Leads Data] Your Premium Account Access"
    self.body = sBody
    self.smtp()
    self.delivery_time = now()
    self.save()
  end
end


class NotificationWelcomeToSocialSellingMachine < NotificationWelcome  
  NotificationWelcomeToSocialSellingMachine.dataset = NotificationWelcomeToSocialSellingMachine.dataset.disable_insert_output

  def initialize()
    super
    self.type = Notification::NOTIFICATION_WELCOME_SOCIALSELLINGMACHINE
  end
  
  def send()        
    app_url = self.user.client.division.app_url
    app_port = self.user.client.division.app_port
    wizard_url = "#{CS_HOME_PAGE_PROTOCOL}://#{app_url}:#{app_port}/prospecting/pipeline/new/step1"
    offer_url = "#{CS_HOME_WEBSITE}/prospecting/pipeline/new/welcome"
    reset_url = "#{CS_HOME_WEBSITE}/forgot"
    
    sContent = 
      "<p><b>Congratulations, you just made a VERY wise decision.</b><br>" +
      "The <b>Social Selling Machine</b> program that we're launching (and you now have access to) is very, VERY powerful.</p>" +
      
      "<p>In fact, We deployed this service privately for our clients in several businesses in several different industries and it worked AMAZINGLY! " +
      "There is ZERO reason it can't do the same for you.</p>" + 

      "<p>" +
      "Below is the email to access your account:<br/>" +
      "<b>email</b>:#{self.user.email}<br/>" +
      "</p>" + 

      "<p>" +
      "If you don't remember your password, you can reset it <a href='#{reset_url}'><b>here</b></a>." +
      "</p>" + 

      "<p>" +
      "Take a few minutes to login at <a href='#{CS_LOGIN_PAGE}'><b>#{APP_NAME}</b></a> (our user dashboard) and check out all our services. We have really great stuff!" +
      "</p>" + 

      "<p>If you didn't complete our <a href='#{wizard_url}'><b>3-step wizard</b></a> yet, go <a href='#{wizard_url}'><b>here</b></a> now. It's very simple, and you will get your selling campaign ready in 5 minutes or less.</p>" + 

      "<p>If you are still running free, maybe you should consider our <a href='#{offer_url}' target='_window'><b>15-day trial for $1</b></a>. This is a limited time offer, and it can be closed at any moment.<p/>"
      
    sBody = NOTIFICATION_BODY_TEMPLATE.gsub(NOTIFICATION_CONTENT_MERGE_TAG, sContent) 

    if (self.delivery_time != nil)
      raise "This notification has been already delivered."
    end
    self.subject = "Welcome to the Social Selling Machine"
    self.body = sBody
    self.smtp()
    self.delivery_time = now()
    self.save()
  end
end # class NotificationWelcomeToSocialSellingMachine 
