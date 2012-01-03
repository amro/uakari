require 'action_mailer'

class UakariDeliveryHandler
  attr_accessor :settings

  def initialize options
    self.settings = {:track_opens => true, :track_clicks => true}.merge(options)
  end

  def deliver! message
    message_payload = {
      :track_opens => settings[:track_opens],
      :track_clicks => settings[:track_clicks],
      :message => {
        :subject => message.subject,
        :from_name => settings[:from_name] || message[:from].display_names.first,
        :from_email => message[:from].addresses.first,
        :to_email => message[:to].addresses,
        :to_name => message[:to].display_names,
        :cc_email => message[:cc].addresses,
        :cc_name => message[:cc].display_names,
        :bcc_name => message[:bcc].display_names,
        :bcc_email => message[:bcc].addresses
      }
    }

    mime_types = {
      :html => "text/html",
      :text => "text/plain"
    }

    get_content_for = lambda do |format|
      content = message.send(:"#{format}_part")
      content ||= message if message.content_type =~ %r{#{mime_types[format]}}
      content
    end

    [:html, :text].each do |format|
      content = get_content_for.call(format)
      message_payload[:message][format] = content.body if content
    end

    message_payload[:tags] = build_tags(message)

    Uakari.new(settings[:api_key]).send_email(message_payload)
  
  end
  
  private
  
  def build_tags(message)
    tags = []
    tags = tags | settings[:tags] if settings[:tags]   # tags set in Uakari config
    tags = tags | extract_message_tags(message)
  end
  
  def extract_message_tags(message)
    [*message[:tags]].collect { |t| t.to_s }
  end


end
ActionMailer::Base.add_delivery_method :uakari, UakariDeliveryHandler
