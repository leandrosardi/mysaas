require 'lib/email'

module BlackStack
  module Core
    include BlackStack::Core::EmailDeliveryModule

    class Notification < Sequel::Model(:notification)
      many_to_one :user, :class=>:'BlackStack::User', :key=>:id_user

      # email body configuration
      @@logo_url = 'https://connectionsphere.com/core/images/logo/logo-32-01.png'
      @@signature_picture_url = 'https://connectionsphere.com/core/images/leandro_sardi.png'
      @@signature_name = 'Leandro D. Sardi'
      @@signature_position = 'Founder & CEO'

      # replace the merge-tag <CONTENT HERE> for the content of the email
      NOTIFICATION_CONTENT_MERGE_TAG = "<CONTENT HERE>"
      NOTIFICATION_BODY_TEMPLATE =
      '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'+
      '<html xmlns="http://www.w3.org/1999/xhtml">'+
      '<head>'+
      '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />'+
      '<title>Invitation</title>'+
      "<style>" +
      "body { font-family: Arial; } " +
      "a { text-decoration:none; } " +
      "a.bold { font-weight: bold; } " +
      "p { font-size:16px; } " +
      "span { font-family: Arial; 'Courier New', Courier, Arial; font-size:16px; overflow: hidden; padding: 20px; } " +
      "span.record { color: rgb(55,55,55); font-size:16px; } " +
      "span.headline { color: rgb(125,125,125); font-size:16px; } " +
      "span.gctlabel { position:relative;top:-5px; color:white; background-color:rgb(0,225,34); padding: 5px; text-align: center; font-size:12px; -webkit-border-radius:10px;-moz-border-radius:10px;border-radius:10px; } " +
      ".medium-green-button {text-align:center;vertical-align:middle;background-color:rgb(34,177,76);float:left;-webkit-border-radius:10px;-moz-border-radius:7px;border-radius:7px;padding-top:7px;padding-bottom:10px;padding-left:10px;padding-right:10px;font-size:14px;font-family:Arial;color:rgb(245,245,245);} " +
      ".medium-blue-button {text-align:center;vertical-align:middle;background-color:rgb(0,128,255);float:left;-webkit-border-radius:10px;-moz-border-radius:7px;border-radius:7px;padding-top:7px;padding-bottom:10px;padding-left:10px;padding-right:10px;font-size:14px;font-family:Arial;color:rgb(245,245,245);} " +
      ".container{width:100%}" +
      ".row-fluid .span12{width:100%;*width:99.94252873563218%}" +
      ".row-fluid .span11{width:91.37931034482759%;*width:91.32183908045977%}" +
      ".row-fluid .span10{width:82.75862068965517%;*width:82.70114942528735%}" +
      ".row-fluid .span9{width:74.13793103448276%;*width:74.08045977011494%}" +
      ".row-fluid .span8{width:65.51724137931035%;*width:65.45977011494253%}" +
      ".row-fluid .span7{width:56.896551724137936%;*width:56.83908045977012%}" +
      ".row-fluid .span6{width:48.275862068965516%;*width:48.2183908045977%}" +
      ".row-fluid .span5{width:39.6551724137931%;*width:39.59770114942529%}" +
      ".row-fluid .span4{width:31.03448275862069%;*width:30.977011494252874%}" +
      ".row-fluid .span3{width:22.413793103448278%;*width:22.35632183908046%}" +
      ".row-fluid .span2{width:13.793103448275861%;*width:13.735632183908045%}" +
      ".row-fluid .span1{width:5.172413793103448%;*width:5.114942528735632%}" +
      ".big-green-button {text-align:center;vertical-align:middle;background-color:rgb(34,177,76);display:block;float:left;width:100%;-webkit-border-radius:10px;-moz-border-radius:10px;border-radius:10px;padding-top:20px;padding-bottom:20px;padding-left:20px;padding-right:20px;font-size:28px;font-family:Arial;color:rgb(245,245,245);}" +
      ".widget-chat .message>img{display:block;float:left;height:40px;margin-bottom:-40px;width:40px;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}" +
      ".widget-chat .message>div{display:block;float:left;font-size:12px;margin-top:-3px;margin-bottom:15px;padding-left:55px;width:100%;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}" +
      ".widget-chat .message>div>div{background:rgba(0,0,0,0.04);font-size:13px;padding:7px 12px 9px 12px;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px}" +
      ".widget-chat .message>div>div:before{border-bottom:6px solid transparent;border-right:6px solid rgba(0,0,0,0.04);border-top:6px solid transparent;content:\"\";display:block;height:0;margin:0 0 -12px -18px;position:relative;width:0}" +
      ".widget-chat .message>div>span{color:#bbb}" +
      ".widget-chat .message.right>div>div:before{border-left:6px solid rgba(0,0,0,0.04);border-right:0;float:right;left:18px;margin-left:0}" +
      ".widget-chat .message.right>img{float:right}" +
      ".widget-chat .message.right>div{padding-left:0;padding-right:55px}" +
      ".widget-chat .widget-actions{border-top:1px solid rgba(0,0,0,0.08);margin-top:10px}" +
      ".widget-chat form{margin:0}" +
      ".widget-chat form>div{margin:-30px 100px 0 0}" +
      ".widget-chat form>div textarea," +
      ".widget-chat form>div input[type=text]{display:block;width:100%}" +
      ".widget-chat form .btn{display:inline-block;width:70px}.widget-messages .message{border-bottom:1px solid rgba(0,0,0,0.08);padding:5px 0;min-height:20px;*zoom:1}.widget-messages .message:before,.widget-messages .message:after{display:table;content:\"\";line-height:0}.widget-messages .message:after{clear:both}.widget-messages .message div,.widget-messages .message a{display:block;height:20px;float:left;position:relative;z-index:2}.widget-messages .message .date{color:#888;float:right;width:50px}.widget-messages .message .action-checkbox{width:20px;line-height:0;font-size:0}.widget-messages .message .from{width:115px;padding-left:5px;overflow:hidden;color:#444}.widget-messages .message .title{display:block!important;height:auto;min-height:20px;white-space:normal;z-index:1;width:100%;margin-top:-20px;padding:0 55px 0 145px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box}.widget-messages .message.unread .title{font-weight:600}.box.widget-messages .message,.box .widget-messages .message{margin:0 -20px;padding-left:20px;padding-right:20px}.widget-status-panel{*zoom:1}.widget-status-panel:before,.widget-status-panel:after{display:table;content:\"\";line-height:0}.widget-status-panel:after{clear:both}.widget-status-panel .status{border-right:1px solid rgba(0,0,0,0.12);text-align:center}.widget-status-panel .status:last-child{border-right:0}.widget-status-panel .status>a{color:#444;display:block;line-height:12px;height:12px;margin:10px 0 -22px 0;position:relative;width:30px;-webkit-box-sizing:border-box;-moz-box-sizing:border-box;box-sizing:border-box;opacity:.15;filter:alpha(opacity=15);-webkit-transition:all .2s;-moz-transition:all .2s;-o-transition:all .2s;transition:all .2s}.widget-status-panel .status>a:hover{text-decoration:none;opacity:.6;filter:alpha(opacity=60)}.widget-status-panel .status .value,.widget-status-panel .status .caption{width:100%}.widget-status-panel .status .value{color:#888;font-size:31px;height:100px;line-height:100px}.widget-status-panel .status .caption{border-top:1px solid rgba(0,0,0,0.12);color:#666;font-size:12px;height:30px;line-height:30px;text-transform:uppercase;-webkit-box-shadow:rgba(255,255,255,0.75) 0 1px 0 inset;-moz-box-shadow:rgba(255,255,255,0.75) 0 1px 0 inset;box-shadow:rgba(255,255,255,0.75) 0 1px 0 inset}.widget-status-panel.light{background:0;border:1px solid rgba(0,0,0,0.12);-webkit-box-shadow:rgba(255,255,255,0.75) 0 1px 0,rgba(255,255,255,0.75) 0 1px 0 inset;-moz-box-shadow:rgba(255,255,255,0.75) 0 1px 0,rgba(255,255,255,0.75) 0 1px 0 inset;box-shadow:rgba(255,255,255,0.75) 0 1px 0,rgba(255,255,255,0.75) 0 1px 0 inset}@media(max-width:767px){.widget-status-panel .status{border-bottom:1px solid rgba(0,0,0,0.12);border-right:none!important;-webkit-box-shadow:rgba(255,255,255,0.75) 0 1px 0;-moz-box-shadow:rgba(255,255,255,0.75) 0 1px 0;box-shadow:rgba(255,255,255,0.75) 0 1px 0}.widget-status-panel .status:last-child{border-bottom:0;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none}}.widget-stars-rating,.widget-stars-rating li{padding:0;margin:0;list-style:none;display:inline-block}.widget-stars-rating a,.widget-stars-rating li a{display:block;color:#bbb;text-decoration:none;text-align:center;font-size:15px}.widget-stars-rating .active a{color:#3690e6}.widget-stream .stream-empty{color:#ccc;font-size:16px;font-weight:600;font-style:italic;text-align:center}.widget-stream .stream-event{border-bottom:1px solid rgba(0,0,0,0.08);min-height:34px;padding:15px 0;opacity:0;filter:alpha(opacity=0)}.widget-stream .stream-event:last-child{border-bottom:0;padding-bottom:0}.widget-stream .stream-icon{border-radius:3px;display:block;font-size:17px;line-height:34px;height:34px;margin-bottom:-34px;text-align:center;width:34px}.widget-stream .stream-time{color:#888;display:block;float:right;font-size:12px;line-height:15px;height:15px}.widget-stream .stream-message,.widget-stream .stream-caption{display:block;margin-left:46px;margin-right:50px}.widget-stream .stream-caption{font-size:12px;font-weight:600;line-height:15px;text-transform:uppercase}.box .widget-stream{margin:0 -20px}.box .widget-stream .stream-event{padding-left:20px;padding-right:20px}.widget-maps img{max-width:none!important}.widget-maps label{display:inline!important;width:auto!important}.widget-maps .gmnoprint{line-height:normal!important}.com{color:#93a1a1}.lit{color:#195f91}.pun,.opn,.clo{color:#93a1a1}.fun{color:#dc322f}.str,.atv{color:#D14}.kwd,.prettyprint .tag{color:#1e347b}.typ,.atn,.dec,.var{color:teal}.pln{color:#48484c}.prettyprint{padding:8px;background-color:#f7f7f9;border:1px solid #e1e1e8}.prettyprint.linenums{-webkit-box-shadow:inset 40px 0 0 #fbfbfc,inset 41px 0 0 #ececf0;-moz-box-shadow:inset 40px 0 0 #fbfbfc,inset 41px 0 0 #ececf0;box-shadow:inset 40px 0 0 #fbfbfc,inset 41px 0 0 #ececf0}ol.linenums{margin:0 0 0 33px}ol.linenums li{padding-left:12px;color:#bebec5;line-height:20px;text-shadow:0 1px 0 #fff}" +
      "</style>" +
      '</head>'+
      '<body style="background-color:rgb(225,225,225);width:100%" width="100%">' + 
      '<section class="container">' +
      "<table style='background-color:rgb(255,255,255);width:75%;align:center;horizontal-align:center;padding:20px;' align='center'>" +
      "<!--logo-->" + 
      "<tr><td align='center' style='text-align:center;'><img src='#{@@logo_url}' width='75px' height='75px' /></td></tr>" + 
      "<tr>" +
      "<td>" +
      NOTIFICATION_CONTENT_MERGE_TAG +
      "</td>" +
      "<tr>" +
      "<tr><td height='5px'><br/></td></tr>" +
      "<!--signature-->" + 
      "<tr><td>" +
      " <p>Warmest Regards.<br/>#{@@signature_name}.<br/>#{@@signature_position}, <a href='#{COMPANY_URL}'>#{COMPANY_NAME}</a></p>" + 
      "</td></tr>" +
      "<tr><td><img src='#{@@signature_picture_url}' width='100px' height='100px' /></td></tr>" + 
      "</table>" +  
      '</section>' +   
      '</body>' +
      '</html>'

      def body()
        raise "This is an abstract class"
      end

      def smtp()
=begin
        BlackStack::Core::Notification::delivery (
          NOTIFICATIONS[:smtp_url], 
          NOTIFICATIONS[:smtp_port],
          NOTIFICATIONS[:smtp_user],
          NOTIFICATIONS[:smtp_password],
          self.name_to, 
          self.email_to, 
          self.subject,
          self.body,
          self.name_from,
          self.email_from
        ) 
=end
      end # def smtp     
    end # class Notification
  end # module Core
end # module BlackStack