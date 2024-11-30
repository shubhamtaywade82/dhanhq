# frozen_string_literal: true

require "faraday"
require "json"

module Dhanhq
  # Provides methods to interact with the DhanHQ Trading API.
  class API
    # Initializes a new API client using the current configuration.
    #
    # @example
    #   api = Dhanhq::API.new
    def initialize
      @connection = Faraday.new(url: Dhanhq.configuration.base_url) do |faraday|
        faraday.headers["access-token"] = Dhanhq.configuration.access_token
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["Accept"] = "application/json"
        faraday.adapter Faraday.default_adapter
      end
    end

    # Retrieves the list of orders from the API.
    #
    # @return [Hash] A hash containing the response data.
    # @raise [RuntimeError] If the API call fails.
    def order_list
      request("/orders", :get)
    end

    # Places a new order through the API.
    #
    # @param params [Hash] A hash containing the order parameters.
    # @option params [String] :securityId The security ID for the order.
    # @option params [String] :transactionType The transaction type (e.g., "BUY" or "SELL").
    # @option params [Integer] :quantity The quantity of the order.
    # @option params [Float] :price The price of the order.
    # @option params [String] :productType The product type (e.g., "CNC").
    # @option params [String] :orderType The order type (e.g., "LIMIT").
    # @option params [String] :validity The validity period of the order (e.g., "DAY").
    #
    # @return [Hash] A hash containing the response data.
    # @raise [RuntimeError] If the API call fails.
    def place_order(params)
      request("/orders", :post, params)
    end

    def fundlimit
      request "/fundlimit", :get
    end

    private

    # Makes a request to the API.
    #
    # @param endpoint [String] The API endpoint.
    # @param method [Symbol] The HTTP method (e.g., :get, :post).
    # @param payload [Hash, nil] The request payload for POST requests.
    #
    # @return [Hash] The parsed JSON response from the API.
    # @raise [RuntimeError] If the response cannot be parsed or is an error.
    def request(endpoint, method, payload = nil)
      response = case method
                 when :get
                   @connection.get(endpoint)
                 when :post
                   @connection.post(endpoint) { |req| req.body = payload.to_json }
                 end

      parse_response(response)
    end

    # Parses the API response.
    #
    # @param response [Faraday::Response] The response object from Faraday.
    #
    # @return [Hash] The parsed response body.
    # @raise [RuntimeError] If the response cannot be parsed or is an error.
    def parse_response(response)
      body = JSON.parse(response.body)
      raise "HTTP Error: #{response.status} - #{body["error_message"] || body}" unless response.status == 200

      body
    rescue JSON::ParserError
      raise "Failed to parse response: #{response.body}"
    end
  end
end
