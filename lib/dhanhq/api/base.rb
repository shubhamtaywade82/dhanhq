# frozen_string_literal: true

module Dhanhq
  module Api
    class Base
      class << self
        # Initializes or returns a shared connection instance.
        #
        # @return [Faraday::Connection] The Faraday connection instance.
        def connection
          @connection ||= Dhanhq::Support::FaradayConnection.build
        end

        # Sends an HTTP request using Faraday and processes the response.
        #
        # @param method [Symbol] The HTTP method (:get, :post, :put, :delete).
        # @param path [String] The endpoint path (e.g., "/orders").
        # @param params [Hash] The request parameters.
        # @return [Hash] Parsed JSON response.
        # @raise [Dhanhq::Errors::ClientError] for 4xx errors.
        # @raise [Dhanhq::Errors::ServerError] for 5xx errors.
        def request(method, path, params = {})
          response = connection.send(method, path, json_params(method, params))
          parse_response(response)
        rescue Faraday::ConnectionFailed => e
          raise Dhanhq::Errors::ClientError.new("Connection error: #{e.message}", nil, {})
        end

        private

        # Parses and validates the response from the API.
        #
        # @param response [Faraday::Response] The raw Faraday response object.
        # @return [Hash] Parsed JSON response.
        # @raise [Dhanhq::Errors::ClientError] for 4xx errors.
        # @raise [Dhanhq::Errors::ServerError] for 5xx errors.
        def parse_response(response)
          body = begin
            JSON.parse(response.body)
          rescue StandardError
            {}
          end

          case response.status
          when 200...300
            body
          when 400...499
            raise Dhanhq::Errors::ClientError.new(
              body["message"] || "Client error",
              response.status,
              body
            )
          when 500...599
            raise Dhanhq::Errors::ServerError.new(
              body["message"] || "Internal Server Error",
              response.status,
              body
            )
          else
            raise StandardError, "Unexpected response status: #{response.status}"
          end
        end

        # Formats request parameters for the API.
        #
        # @param method [Symbol] The HTTP method.
        # @param params [Hash] The request parameters.
        # @return [Hash, nil] Parameters formatted for the HTTP request body or query string.
        def json_params(method, params)
          return if method == :get

          params.to_json
        end

        # Validates parameters using the specified validator class.
        #
        # @param params [Hash] The parameters to validate.
        # @param validator_class [Class] The validator class to use.
        # @raise [Dhanhq::Errors::ValidationError] if validation fails.
        def validate(params, validator_class)
          validation = validator_class.new.call(params)
          raise Dhanhq::Errors::ValidationError, validation.errors.to_h if validation.failure?
        end
      end
    end
  end
end
