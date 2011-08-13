# uakari

Uakari is a simple API wrapper for the [MailChimp STS API](http://http://apidocs.mailchimp.com/sts/1.0/) 1.0, which wraps Amazon SES.

##Installation

    $ gem install uakari
    
##Requirements

A paid MailChimp account, MailChimp API key, and Amazon AWS account with SES ready to go. You can see your API keys [here](http://admin.mailchimp.com/account/api). Caveats include the inability to send to unconfirmed email addresses until you request (and Amazon provides) production access to your AWS account.

##Usage

Create an instance of the API wrapper:

    u = Uakari.new(apikey)

### Sending a message

Send a message so a single email:

    response = u.send_email({
        :track_opens => true, 
        :track_clicks => true, 
        :message => {
            :subject => 'your subject', 
            :html => '<html>hello world</html>', 
            :text => 'hello world', 
            :from_name => 'John Smith', 
            :from_email => 'support@somedomain.com', 
            :to_email => ['user@someotherdomain.com']
        }
    })

Calling other methods is as simple as calling API methods directly on the Uakari instance (e.g. u.get_send_quota, u.verify_email_address, and so on). Check the API [documentation](http://apidocs.mailchimp.com/sts/1.0/) for more information about API calls and their parameters.


### Plugging into ActionMailer

You use tell ActionMailer to send mail using Mailchimp STS by adding the follow to to your config/application.rb or to the proper environment (eg. config/production.rb) :
    
    config.action_mailer.delivery_method = :uakari
    config.action_mailer.uakari_settings = {
          :apikey => your_mailchimp_apikey,
          :track_clicks => true,
          :track_opens  => true,
          :from_name    => "Stafford Brooke"
     }


### Other Stuff

Uakari defaults to a 30 second timeout. You can optionally set your own timeout (in seconds) like so:

    u.timeout = 5

##Thanks

* [Stafford Brooke](https://github.com/srbiv)
* Rails for camelize gsub

##Copyrights

* Copyright (c) 2010 Amro Mousa. See LICENSE.txt for details.
* MailChimp (c) 2001-2011 The Rocket Science Group.
* Amazon SES (c) 2011 Amazon