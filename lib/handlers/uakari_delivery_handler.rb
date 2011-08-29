require 'action_mailer'

class UakariDeliveryHandler
  attr_accessor :settings

  def initialize options
    @uakari = Uakari.new(options[:apikey])
    self.settings = {:track_opens => true, :track_clicks => true, :tags => nil}.merge(options)
  end

  def deliver! message
    message_payload = {
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
    }
    message_payload[:tags] = settings[:tags] if settings[:tags]

    @uakari.send_email(message_payload)
  end

end
ActionMailer::Base.add_delivery_method :uakari, UakariDeliveryHandler