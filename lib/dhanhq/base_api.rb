# frozen_string_literal: true

module Dhanhq
  module Api
    # BaseApi class for all API modules
    class BaseApi
      class << self
        # Provides a shared client instance
        #
        # @return [Dhanhq::Client] The initialized client
        def client
          @client ||= Dhanhq::Client.new
        end

        # Helper method for making requests
        #
        # @param method [Symbol] HTTP method (:get, :post, etc.)
        # @param endpoint [String] API endpoint (relative to base_url)
        # @param params [Hash] Request parameters
        # @return [Hash] Parsed response
        def request(method, endpoint, params = {})
          client.request(method, endpoint, params)
        end

        def handle_response(response)
          case response.status
          when 200..299
            JSON.parse(response.body) unless response.body.nil? || response.body.strip.empty?
          when 400..499
            raise Dhanhq::Errors::ApiError, "Client Error: #{response.status} - #{response.body}"
          when 500..599
            raise Dhanhq::Errors::ApiError, "Server Error: #{response.status} - #{response.body}"
          else
            raise Dhanhq::Errors::ApiError, "Unexpected Error: #{response.status} - #{response.body}"
          end
        rescue JSON::ParserError => e
          raise Dhanhq::Errors::ApiError, "Invalid JSON Response: #{response.body} - #{e.message}"
        end
      end
    end
  end
end
