require 'httparty'
require 'json'
require 'cgi'
if defined?(ActionMailer)
  require File.join(File.dirname(__FILE__), 'handlers', 'uakari_delivery_handler')
end

class Uakari
  include HTTParty
  default_timeout 30

  attr_accessor :api_key, :timeout

  def initialize(api_key = nil, extra_params = {})
    @api_key = api_key || ENV['MC_API_KEY'] || ENV['MAILCHIMP_API_KEY'] || self.class.api_key
    @default_params = {
      :apikey => @api_key,
      :options => {
        :track_opens => true, 
        :track_clicks => true
      }
    }.merge(extra_params)
  end

  def api_key=(value)
    @api_key = value
    @default_params = @default_params.merge({:apikey => @api_key})
  end

  def base_api_url
    dc = (@api_key.nil? || @api_key.empty?) ? '' : "#{@api_key.split("-").last}."
    "https://#{dc}sts.mailchimp.com/1.0/"
  end

  def call(method, params = {})
    url = "#{base_api_url}#{method}"
    params = @default_params.merge(params)
    response = self.class.post(url, :body => params, :timeout => @timeout)
    
    # Some calls (e.g. listSubscribe) return json fragments
    # (e.g. true) so wrap in an array prior to parsing
    JSON.parse('['+response.body+']').first
  end

  def method_missing(method, *args)
    method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
    call(method, *args)
  end

  class << self
    attr_accessor :api_key

    def method_missing(sym, *args, &block)
      new(self.api_key).send(sym, *args, &block)
    end
  end
end
