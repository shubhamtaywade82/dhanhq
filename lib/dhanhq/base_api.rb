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

        # Makes a request through the client
        #
        # @param method [Symbol] HTTP method (:get, :post, etc.)
        # @param endpoint [String] API endpoint (relative to base_url)
        # @param params [Hash] Request parameters
        # @return [Hash, Array] Parsed response
        def request(method, endpoint, params = {})
          response = client.request(method, endpoint, params)
          handle_response(response)
        end

        private

        # Parses and handles the API response
        #
        # @param response [Faraday::Response] The response object
        # @return [Hash, Array] Parsed JSON response
        # @raise [Dhanhq::Errors::ApiError] For invalid or unsuccessful responses
        def handle_response(response)
          case response.status
          when 200..299
            parse_json(response.body)
          when 400..499
            raise_client_error(response)
          when 500..599
            raise_server_error(response)
          else
            raise_generic_error(response)
          end
        end

        # Parses JSON responses safely
        #
        # @param body [String] The response body
        # @return [Hash, Array, nil] Parsed JSON or nil for empty body
        def parse_json(body)
          return nil if body.nil? || body.strip.empty?

          JSON.parse(body)
        rescue JSON::ParserError => e
          raise Dhanhq::Errors::ApiError, "Invalid JSON Response: #{body} - #{e.message}"
        end

        # Raises an error for client-side issues
        #
        # @param response [Faraday::Response] The response object
        def raise_client_error(response)
          raise Dhanhq::Errors::ClientError, "Client Error: #{response.status} - #{response.body}"
        end

        # Raises an error for server-side issues
        #
        # @param response [Faraday::Response] The response object
        def raise_server_error(response)
          raise Dhanhq::Errors::ServerError, "Server Error: #{response.status} - #{response.body}"
        end

        # Raises an error for unexpected scenarios
        #
        # @param response [Faraday::Response] The response object
        def raise_generic_error(response)
          raise Dhanhq::Errors::ApiError, "Unexpected Error: #{response.status} - #{response.body}"
        end
      end
    end
  end
end
