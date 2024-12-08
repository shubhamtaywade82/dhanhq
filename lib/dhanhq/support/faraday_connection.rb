# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

module Dhanhq
  module Support
    # Provides a reusable Faraday connection for making HTTP requests to the DhanHQ API.
    class FaradayConnection
      # Builds and returns a configured Faraday connection for the DhanHQ API.
      #
      # @return [Faraday::Connection] A Faraday connection instance with the required configuration.
      def self.build
        Faraday.new(url: Dhanhq.configuration.base_url) do |conn|
          # Request middleware
          conn.request :json

          # Response middleware
          conn.response :json, content_type: /\bjson$/

          # Headers
          conn.headers["Content-Type"] = "application/json"
          conn.headers["access-token"] = Dhanhq.configuration.access_token
          conn.headers["X-Client-Id"] = Dhanhq.configuration.client_id

          # Adapter
          conn.adapter Faraday.default_adapter
        end
      end
    end
  end
end
