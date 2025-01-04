# frozen_string_literal: true

require_relative "../contracts/base_contract"

module Dhanhq
  module API
    # Base class for API interactions with the Dhanhq API.
    #
    # The `Base` class provides common methods for interacting with the Dhanhq API, including
    # `GET`, `POST`, `PUT`, and `DELETE` requests. It also includes parameter validation functionality
    # using contracts.
    #
    # Example usage:
    #   class Orders < Dhanhq::API::Base
    #     def self.place_order(params)
    #       validated_params = validate_with(Dhanhq::Contracts::PlaceOrderContract, params)
    #       post("/orders", validated_params)
    #     end
    #   end
    #
    #   response = Orders.place_order({
    #     transactionType: "BUY",
    #     securityId: "1001",
    #     quantity: 10,
    #     price: 150.0
    #   })
    #
    # @see Dhanhq::Client For HTTP request handling.
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class Base
      class << self
        # Performs a GET request to the API.
        #
        # @param path [String] The API endpoint path.
        # @param params [Hash] Query parameters for the GET request.
        # @return [Hash, Array] The parsed JSON response.
        def get(path, params = {})
          client.get(path, params)
        end

        # Performs a POST request to the API.
        #
        # @param path [String] The API endpoint path.
        # @param body [Hash] The body for the POST request.
        # @return [Hash, Array] The parsed JSON response.
        def post(path, body = {})
          client.post(path, body)
        end

        # Performs a PUT request to the API.
        #
        # @param path [String] The API endpoint path.
        # @param body [Hash] The body for the PUT request.
        # @return [Hash, Array] The parsed JSON response.
        def put(path, body = {})
          client.put(path, body)
        end

        # Performs a DELETE request to the API.
        #
        # @param path [String] The API endpoint path.
        # @param params [Hash] Query parameters for the DELETE request.
        # @return [Hash, Array] The parsed JSON response.
        def delete(path, params = {})
          client.delete(path, params)
        end

        # Validates request parameters using a specified validation contract.
        #
        # @param contract_class [Class] The validation contract class.
        # @param params [Hash] The parameters to validate.
        # @return [Hash] The validated parameters.
        # @raise [Dhanhq::Error] If validation fails.
        #
        # @example Validating parameters before making a request:
        #   validated_params = validate_with(Dhanhq::Contracts::PlaceOrderContract, {
        #     transactionType: "BUY",
        #     securityId: "1001",
        #     quantity: 10,
        #     price: 150.0
        #   })
        #   post("/orders", validated_params)
        def validate_with(contract_class, params)
          validation = contract_class.new.call(params)
          raise Dhanhq::Error, validation.errors.to_h unless validation.success?

          validation.to_h
        end

        private

        # Returns the Dhanhq API client.
        #
        # @return [Dhanhq::Client] The client instance for API requests.
        def client
          @client ||= Dhanhq::Client.new
        end
      end
    end
  end
end
