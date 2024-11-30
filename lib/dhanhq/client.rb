# frozen_string_literal: true

require "faraday"
require "json"
module Dhanhq
  # The Client class serves as the central point for interacting with the DhanHQ API.
  # It provides instances of API modules (like Orders, Portfolio) and handles requests and responses.
  #
  # @example Initialize the Client and interact with the Orders API:
  #   client = Dhanhq::Client.new
  #   orders = client.orders.get_orders_list
  #
  # @see Dhanhq::Api::Orders for Orders API endpoints
  class Client
    def initialize
      Dhanhq.configuration.validate!

      @connection = Faraday.new(url: Dhanhq.configuration.base_url) do |faraday|
        faraday.headers["access-token"] = Dhanhq.configuration.access_token
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        faraday.adapter Faraday.default_adapter
      end
    end

    # Makes an API request
    #
    # @param method [Symbol] HTTP method (:get, :post, :put, :delete)
    # @param endpoint [String] API endpoint (relative to base_url)
    # @param params [Hash] Request parameters
    # @return [Hash] Parsed JSON response
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
    # @return [Hash] Parsed JSON if successful
    # @raise [StandardError] If the response indicates an error
    def handle_response(response)
      raise StandardError, "API Error: #{response.status} #{response.body}" unless response.success?

      return {} if response.body.nil? || response.body.strip.empty?

      JSON.parse(response.body)
    rescue JSON::ParserError
      raise StandardError, "Invalid JSON response: #{response.body}"
    end
  end
end
