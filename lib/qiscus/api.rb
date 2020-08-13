require 'httparty'
require 'json'
require 'qiscus/client'

module Qiscus
  class Api
    include HTTParty

    Qiscus::Client::POST_METHODS.each do |method|
      define_singleton_method(method) do |data|
        res = self.post(
          "#{self.end_point}/#{method}",
          headers: self.headers,
          body: data.to_json
        ).to_json
        JSON.parse(res, symbolize_names: true)
      end
    end

    Qiscus::Client::GET_METHODS.each do |method|
      define_singleton_method(method) do |query|
        res = self.get(
          "#{self.end_point}/#{method}",
          headers: self.headers,
          query: query
        ).to_json
        JSON.parse(res, symbolize_names: true)
      end
    end

    private
      def self.headers
        {
          "QISCUS_SDK_SECRET": "#{Qiscus.sdk_secret || '2820ae9dfc5362f7f3a10381fb89afc7'}",
          "QISCUS-SDK-APP-ID": "#{Qiscus.sdk_app_id || 'sdksample'}",
          "Content-Type": "application/json"
        }
      end

      def self.end_point
        "https://#{Qiscus.end_point || 'api.qiscus.com'}/api/#{Qiscus.api_version || 'v2.1'}/rest"
      end
  end
end
