require 'action_mailer'

class UakariDeliveryHandler
  attr_accessor :settings
  
  def initialize options
    @uakari = Uakari.new(options[:apikey])
    self.settings = {:track_opens => true, :track_clicks => true}.merge(options)
  end
  
  def deliver! message
    @uakari.send_email({
     :track_opens => settings[:track_opens],
     :track_clicks => settings[:track_clicks],
     :message => {
       :subject => message.subject,
       :html => message.text_part.body,
       :text => message.html_part.body,
       :from_name => settings[:from_name],
       :from_email => message.from.first,
       :to_email => message.to
     }
    })
  end

end
ActionMailer::Base.add_delivery_method :uakari, UakariDeliveryHandler