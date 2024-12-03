# frozen_string_literal: true

require "faraday"
require "json"

module Dhanhq
  # The Client class serves as the central point for interacting with the DhanHQ API.
  # It provides a configured Faraday connection and facilitates API requests.
  #
  # @example Making an API call
  #   client = Dhanhq::Client.new
  #   response = client.request(:get, "/orders")
  #
  # @see Dhanhq::Api for specific API modules
  class Client
    attr_reader :connection

    def initialize
      # Validate the configuration to ensure required attributes are present
      Dhanhq.configuration.validate!

      @connection = Faraday.new(url: Dhanhq.configuration.base_url) do |faraday|
        faraday.headers["access-token"] = Dhanhq.configuration.access_token
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        faraday.request :json # Automatically encode request body as JSON
        faraday.response :json, content_type: /\bjson$/ # Automatically parse JSON response
        faraday.adapter Faraday.default_adapter
      end
    end

    # Makes an API request
    #
    # @param method [Symbol] HTTP method (:get, :post, :put, :delete)
    # @param endpoint [String] API endpoint (relative to base_url)
    # @param params [Hash] Request parameters (optional)
    # @return [Hash, Array] Parsed JSON response
    # @raise [Dhanhq::Error] If the response indicates an error
    def request(method, endpoint, params = {})
      response = @connection.send(method) do |req|
        req.url endpoint
        req.body = params.to_json unless params.nil? || params.empty?
      end

      handle_response(response)
    end

    private

    # Handles the API response
    #
    # @param response [Faraday::Response] The response object
    # @return [Hash, Array] Parsed JSON if successful
    # @raise [Dhanhq::Error] If the response status is not successful
    def handle_response(response)
      raise Dhanhq::Error.new(status: response.status, body: response.body) unless response.success?

      # Return an empty hash if the response body is nil or blank
      return {} if response.body.nil? || response.body.strip.empty?

      response.body
    rescue JSON::ParserError
      raise Dhanhq::Error.new(status: response.status, body: "Invalid JSON response")
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
