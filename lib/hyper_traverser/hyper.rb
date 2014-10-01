require_relative 'hyper_interpreter'
require 'net/http'
require 'json'

#TODO keep tcp connection open?
module HyperTraverser
  class Hyper
    class << self
      def start(url)
        take_action url, "GET"
      end

      def take_action(url, method, payload = nil)
        uri = URI.parse url
        request = Object.const_get("Net::HTTP::#{method.capitalize}").new uri
        if payload
          request.set_form_data payload
        end
        http = Net::HTTP.new(uri.hostname, uri.port)
        response = http.request request
        data = JSON.parse(response.body)
        HyperInterpreter.create data
      end

    end
  end
end
