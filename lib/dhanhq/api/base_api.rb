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
          client.request(method, endpoint, params)
        rescue Dhanhq::Error => e
          handle_error(e)
        end

        # Validates parameters using a given schema
        #
        # @param params [Hash] Parameters to validate
        # @param schema [Dry::Validation::Contract] Validation schema
        def validate_params(params, schema)
          result = schema.call(params)
          raise Dhanhq::Errors::ValidationError, result.errors.to_h if result.failure?
        end

        private

        # Handles API errors
        #
        # @param error [Dhanhq::Error] The raised error
        def handle_error(error)
          case error.status
          when 400..499
            raise Dhanhq::Errors::ClientError, "Client Error: #{error.status} - #{error.body}"
          when 500..599
            raise Dhanhq::Errors::ServerError, "Server Error: #{error.status} - #{error.body}"
          else
            raise Dhanhq::Errors::ApiError, "Unexpected Error: #{error.status} - #{error.body}"
          end
        end
      end
    end
  end
end
