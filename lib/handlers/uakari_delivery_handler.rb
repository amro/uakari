module Uakari
  class DeliveryHandler
    attr_accessor :settings
    
    def initialize options
      self.settings = {:track_opens => true, :track_clicks => true, :tags => nil}.merge(options)
    end
    def deliver! message      
     Uakari.send_email({
        :track_opens => Uakari.options[:track_opens],
        :track_clicks => Uakari.options[:track_clicks],
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
end
ActionMailer::Base.add_delivery_method :uakari, Uakari::DeliveryHandler
