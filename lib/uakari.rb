require 'httparty'
require 'json'

class Uakari
  include HTTParty
  default_timeout 30

  attr_accessor :apikey, :timeout

  def initialize(apikey = nil, extra_params = {})
    @apikey = apikey
    @default_params = {:apikey => apikey}.merge(extra_params)
  end

  def apikey=(value)
    @apikey = value
    @default_params = @default_params.merge({:apikey => @apikey})
  end

  def base_api_url
    dc = @apikey.blank? ? '' : "#{@apikey.split("-").last}."
    "https://#{dc}sts.mailchimp.com/1.0/"
  end

  def call(method, params = {})
    url = "#{base_api_url}#{method}"
    params = params.merge(@default_params)
    response = self.class.post(url, :query => params, :timeout => @timeout)

    begin
      response = JSON.parse(response.body)
    rescue
      response = response.body
    end
    response
  end

  def method_missing(method, *args)
    method = method.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase } #Thanks for the gsub, Rails
    args = {} unless args.length > 0
    args = args[0] if (args.class.to_s == "Array")
    call(method, args)
  end
end