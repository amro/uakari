module Uakari
  class DeliveryHandler
    def deliver! message
     self.send_email({
       :track_opens => @options[:track_opens],
       :track_clicks => @options[:track_clicks],
       :message => {
         :subject => message.subject,
         :html => message.text_part.body,
         :text => message.html_part.body,
         :from_name => @options[:from_name],
         :from_email => message.from.first,
         :to_email => message.to
       }
      })
    end
  end
end
ActionMailer::Base.add_delivery_method :uakari, Uakari::DeliveryHandler