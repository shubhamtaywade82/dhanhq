# frozen_string_literal: true

require "faraday"
require "faraday_middleware"
require "json"

module Dhanhq
  module Support
    # Provides a reusable Faraday connection for making HTTP requests to the DhanHQ API.
    # This class sets up a reusable Faraday connection for API requests.
    class FaradayConnection
      # Builds a Faraday connection with required configurations.
      #
      # @param base_url [String] The base URL for the API (defaults to Dhanhq.configuration.base_url).
      # @param headers [Hash] The headers for the API requests (defaults to configured access token and client ID).
      # @param timeout [Integer] Request timeout in seconds.
      # @return [Faraday::Connection] Configured Faraday connection instance.
      def self.build(url: Dhanhq.configuration.base_url, headers: {}, timeout: 60)
        Faraday.new(url: url) do |conn|
          conn.request :json # Encode requests as JSON
          conn.response :json, content_type: /\bjson$/ # Decode JSON responses
          conn.response :logger if ENV["DHAN_DEBUG"] # Optional logging
          conn.adapter Faraday.default_adapter # Use default adapter (Net::HTTP)

          conn.headers["Accept"] = "application/json"
          conn.headers["Content-Type"] = "application/json"
          conn.headers["access-token"] = Dhanhq.configuration.access_token
          conn.headers["client-id"] = Dhanhq.configuration.client_id

          headers.each { |key, value| conn.headers[key] = value }
          conn.options.timeout = timeout
          conn.options.open_timeout = timeout
        end
      end
    end
  end
end
