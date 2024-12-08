# frozen_string_literal: true

require "faraday"
require "json"

module Dhanhq
  # The Client class serves as the central point for interacting with the DhanHQ API.
  class Client
    attr_reader :connection

    def initialize
      validate_configuration!
      @connection = setup_connection
    end

    # Makes an API request
    #
    # @param method [Symbol] HTTP method (:get, :post, :put, :delete)
    # @param endpoint [String] API endpoint (relative to base_url)
    # @param params [Hash] Request parameters (optional)
    # @return [Hash, Array] Parsed JSON response
    # @raise [Dhanhq::Error] If the response indicates an error
    def request(method, endpoint, params = {})
      response = connection.public_send(method) do |req|
        req.url endpoint
        req.body = params.to_json unless params.empty?
      end

      handle_response(response)
    end

    private

    # Validates the configuration
    def validate_configuration!
      Dhanhq.configuration.validate!
    end

    # Sets up the Faraday connection
    def setup_connection
      Faraday.new(url: Dhanhq.configuration.base_url) do |faraday|
        faraday.headers["access-token"] = Dhanhq.configuration.access_token
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    # Handles the API response
    #
    # @param response [Faraday::Response] The response object
    # @return [Hash, Array] Parsed JSON if successful
    # @raise [Dhanhq::Error] For non-successful responses
    def handle_response(response)
      raise Dhanhq::Error.new(status: response.status, body: response.body || "Unknown error") unless response.success?

      parse_json(response.body)
    end

    # Parses the response body as JSON
    #
    # @param body [String] The response body as a string
    # @return [Hash, Array] Parsed JSON object
    # @raise [Dhanhq::Error] If the body cannot be parsed
    def parse_json(body)
      return {} if body.nil? || body.empty?

      JSON.parse(body.is_a?(String) ? body : body.to_json)
    rescue JSON::ParserError => e
      raise Dhanhq::Error.new(status: 500, body: "Invalid JSON response: #{e.message}")
    end
  end

  # Custom error class for handling API errors
  class Error < StandardError
    attr_reader :status, :body

    def initialize(status:, body:)
      @status = status
      @body = body
      super("API Error: #{status} - #{body}")
    end
  end
end
