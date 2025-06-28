# frozen_string_literal: true

require "faraday"
require "json"
require "active_support/core_ext/hash/indifferent_access" # For HashWithIndifferentAccess

module Dhanhq
  # The `Client` class provides a wrapper around HTTP requests to interact with the Dhanhq API.
  #
  # It uses the Faraday library for HTTP requests, handles JSON encoding/decoding, and integrates
  # with Dhanhq's API authentication via `client_id` and `access_token`.
  #
  # Example usage:
  #   client = Dhanhq::Client.new
  #   response = client.get("/orders", { page: 1 })
  #
  #   # For POST:
  #   response = client.post("/orders", { securityId: "1001", quantity: 10 })
  #
  # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
  class Client
    # Base URL for the Dhanhq API.
    BASE_URL = "https://api.dhan.co/v2"

    # The Faraday connection object.
    #
    # @return [Faraday::Connection] The connection instance used for API requests.
    attr_reader :connection

    # Initializes a new Dhanhq Client instance.
    #
    # @example Create a new client:
    #   client = Dhanhq::Client.new
    #
    # @return [Dhanhq::Client] A new client instance configured for API requests.
    def initialize
      @connection = Faraday.new(url: Dhanhq.configuration.base_url) do |conn|
        conn.request :json
        conn.response :json, content_type: /\bjson$/
        conn.response :logger if ENV["DHAN_DEBUG"]
        conn.adapter Faraday.default_adapter
      end
    end

    # Sends a GET request to the API.
    #
    # @param path [String] The API endpoint path.
    # @param params [Hash] The query parameters for the GET request.
    # @return [Hash, Array] The parsed JSON response.
    # @raise [Dhanhq::Error] If the response indicates an error.
    def get(path, params = {})
      request(:get, path, params)
    end

    # Sends a POST request to the API.
    #
    # @param path [String] The API endpoint path.
    # @param body [Hash] The body of the POST request.
    # @return [Hash, Array] The parsed JSON response.
    # @raise [Dhanhq::Error] If the response indicates an error.
    def post(path, body = {})
      request(:post, path, body)
    end

    # Sends a PUT request to the API.
    #
    # @param path [String] The API endpoint path.
    # @param body [Hash] The body of the PUT request.
    # @return [Hash, Array] The parsed JSON response.
    # @raise [Dhanhq::Error] If the response indicates an error.
    def put(path, body = {})
      request(:put, path, body)
    end

    # Sends a DELETE request to the API.
    #
    # @param path [String] The API endpoint path.
    # @param params [Hash] The query parameters for the DELETE request.
    # @return [Hash, Array] The parsed JSON response.
    # @raise [Dhanhq::Error] If the response indicates an error.
    def delete(path, params = {})
      request(:delete, path, params)
    end

    private

    # Handles HTTP requests to the Dhanhq API.
    #
    # @param method [Symbol] The HTTP method (e.g., :get, :post, :put, :delete).
    # @param path [String] The API endpoint path.
    # @param payload [Hash] The parameters or body for the request.
    # @return [Hash, Array] The parsed JSON response.
    # @raise [Dhanhq::Error] If the response indicates an error.
    def request(method, path, payload)
      response = connection.send(method) do |req|
        req.url path
        headers(req)
        prepare_payload(req, payload, method)
      end
      handle_response(response)
    end

    def headers(req)
      req.headers["access-token"] = Dhanhq.configuration.access_token
      req.headers["client-id"] = Dhanhq.configuration.client_id
      req.headers["Accept"] = "application/json"
      req.headers["Content-Type"] = "application/json"
    end

    def prepare_payload(req, payload, method)
      if method == :get
        req.params = payload if payload.is_a?(Hash)
      elsif payload.is_a?(Hash)
        payload[:dhanClientId] = Dhanhq.configuration.client_id
        req.body = payload.to_json
      end
    end

    # Handles API responses and raises appropriate errors for unsuccessful requests.
    #
    # @param response [Faraday::Response] The response object from the API.
    # @return [Hash, Array] The parsed JSON response for successful requests.
    # @raise [Dhanhq::Error] If the response status indicates an error.
    def handle_response(response)
      case response.status
      when 200..299
        symbolize_keys(response.body)
      else
        handle_error(response)
      end
    end

    def handle_error(response)
      error_message = "#{response.status}: #{response.body}"
      case response.status
      when 400 then raise Dhanhq::Error, "Bad Request: #{error_message}"
      when 401 then raise Dhanhq::Error, "Unauthorized: #{error_message}"
      when 403 then raise Dhanhq::Error, "Forbidden: #{error_message}"
      when 404 then raise Dhanhq::Error, "Not Found: #{error_message}"
      when 500..599 then raise Dhanhq::Error, "Server Error: #{error_message}"
      else raise Dhanhq::Error, "Unknown Error: #{error_message}"
      end
    end

    # Converts response body to a hash with indifferent access (string and symbol keys).
    def symbolize_keys(body)
      body.is_a?(Hash) ? body.with_indifferent_access : body
    end
  end
end
