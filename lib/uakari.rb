require 'httparty'
require 'json'
require 'cgi'
if defined?(ActionMailer)
  require File.join(File.dirname(__FILE__), 'handlers', 'uakari_delivery_handler')
end

module Uakari
  include HTTParty
  default_timeout 30
  
  class << self
    attr_accessor :apikey, :timeout, :options
    
    def base_api_url
      dc = self.apikey.blank? ? '' : "#{self.apikey.split("-").last}."
      "https://#{dc}sts.mailchimp.com/1.0/"
    end

    def call(method, params = {})
      url = "#{base_api_url}#{method}"
      params = self.default_params.merge(params)
      response = self.post(url, :body => params, :timeout => self.timeout)
      begin
        response = JSON.parse(response.body)
      rescue
        response = response.body
      end
      response
    end
    
    def default_params(extra_params = {})
      {
        :apikey => self.apikey,
        :options => {
          :track_opens => true, 
          :track_clicks => true
        }
      }.merge(extra_params)
    end

    def method_missing(method, *args)
      method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
      args = {} unless args.length > 0
      args = args[0] if (args.class.to_s == "Array")
      call(method, args)
    end
    
    def options
      @options ||= {:track_opens => true, :track_clicks => true}
    end
  end
end