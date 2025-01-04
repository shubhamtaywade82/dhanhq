# frozen_string_literal: true

module Dhanhq
  module API
    # Provides methods to manage Forever Orders via Dhanhq's API.
    #
    # The `ForeverOrders` class extends `Dhanhq::API::Base` and offers functionality to create,
    # modify, cancel, and retrieve Forever Orders. It uses validation contracts to ensure
    # that request parameters meet the API's requirements.
    #
    # Example usage:
    #   # Create a Forever Order
    #   ForeverOrders.create({
    #     dhanClientId: "123456",
    #     orderType: "LIMIT",
    #     productType: "CNC",
    #     securityId: "1001",
    #     price: 150.0,
    #     quantity: 10
    #   })
    #
    #   # Modify a Forever Order
    #   ForeverOrders.modify("order123", {
    #     price: 145.0,
    #     quantity: 5
    #   })
    #
    #   # Cancel a Forever Order
    #   ForeverOrders.cancel("order123")
    #
    #   # Fetch all Forever Orders
    #   ForeverOrders.all
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see https://dhanhq.co/docs/v2/forever/ Dhanhq API Documentation
    class ForeverOrders < Base
      class << self
        # Creates a new Forever Order.
        #
        # @param order_params [Hash] The parameters for creating the Forever Order.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Create a Forever Order:
        #   ForeverOrders.create({
        #     dhanClientId: "123456",
        #     orderType: "LIMIT",
        #     productType: "CNC",
        #     securityId: "1001",
        #     price: 150.0,
        #     quantity: 10
        #   })
        def create(order_params)
          validated_params = validate_with(Dhanhq::Contracts::PlaceForeverOrderContract, order_params)
          post("/forever/orders", validated_params)
        end

        # Modifies an existing Forever Order.
        #
        # @param order_id [String] The ID of the Forever Order to modify.
        # @param modify_params [Hash] The parameters for modifying the Forever Order.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Modify a Forever Order:
        #   ForeverOrders.modify("order123", {
        #     price: 145.0,
        #     quantity: 5
        #   })
        def modify(order_id, modify_params)
          validated_params = validate_with(Dhanhq::Contracts::ModifyForeverOrderContract, modify_params)
          put("/forever/orders/#{order_id}", validated_params)
        end

        # Cancels an existing Forever Order.
        #
        # @param order_id [String] The ID of the Forever Order to cancel.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Cancel a Forever Order:
        #   ForeverOrders.cancel("order123")
        def cancel(order_id)
          delete("/forever/orders/#{order_id}")
        end

        # Retrieves all Forever Orders.
        #
        # @return [Array<Hash>] A list of Forever Orders as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Fetch all Forever Orders:
        #   ForeverOrders.all
        def all
          get("/forever/all")
        end
      end
    end
  end
end
