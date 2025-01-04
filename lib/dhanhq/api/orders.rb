# frozen_string_literal: true

require_relative "../contracts/place_order_contract"
require_relative "../contracts/modify_order_contract"
require_relative "../contracts/slice_order_contract"

module Dhanhq
  module API
    # Provides methods to manage orders via Dhanhq's API.
    #
    # The `Orders` class extends `Dhanhq::API::Base` and includes methods to:
    # - Retrieve orders and trades.
    # - Place, modify, and cancel orders.
    # - Handle sliced orders.
    #
    # Example usage:
    #   # Retrieve all orders for the day
    #   orders = Orders.list
    #
    #   # Place a new order
    #   new_order = Orders.place({
    #     dhanClientId: "123456",
    #     transactionType: "BUY",
    #     exchangeSegment: "NSE_EQ",
    #     productType: "CNC",
    #     orderType: "LIMIT",
    #     securityId: "1001",
    #     quantity: 10,
    #     price: 150.0
    #   })
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see Dhanhq::Contracts::PlaceOrderContract For Place Order validation.
    # @see Dhanhq::Contracts::ModifyOrderContract For Modify Order validation.
    # @see Dhanhq::Contracts::SliceOrderContract For Slice Order validation.
    # @see https://dhanhq.co/docs/v2/orders/ Dhanhq API Documentation
    class Orders < Base
      class << self
        # Retrieves the list of all orders for the current day.
        #
        # @return [Array<Hash>] The list of orders as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve all orders for the day:
        #   orders = Orders.list
        def list
          get("/orders")
        end

        # Retrieves the status of an order by its order ID.
        #
        # @param order_id [String] The ID of the order to retrieve.
        # @return [Hash] The order details as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve order details by order ID:
        #   order = Orders.find("order123")
        def find(order_id)
          get("/orders/#{order_id}")
        end

        # Retrieves the status of an order by its correlation ID.
        #
        # @param correlation_id [String] The correlation ID of the order to retrieve.
        # @return [Hash] The order details as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve order details by correlation ID:
        #   order = Orders.find_by_correlation("corr123")
        def find_by_correlation(correlation_id)
          get("/orders/external/#{correlation_id}")
        end

        # Retrieves the list of all trades for the current day.
        #
        # @return [Array<Hash>] The list of trades as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve all trades for the day:
        #   trades = Orders.trades
        def trades
          get("/trades")
        end

        # Retrieves the details of trades for a specific order by its ID.
        #
        # @param order_id [String] The ID of the order for which to retrieve trades.
        # @return [Array<Hash>] The list of trades as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve trades for a specific order:
        #   trades = Orders.trades_by_order("order123")
        def trades_by_order(order_id)
          get("/trades/#{order_id}")
        end

        # Places a new order.
        #
        # @param order_params [Hash] The parameters for placing the order.
        #   Required keys are validated using `PlaceOrderContract`.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Place a new order:
        #   new_order = Orders.place({
        #     dhanClientId: "123456",
        #     transactionType: "BUY",
        #     exchangeSegment: "NSE_EQ",
        #     productType: "CNC",
        #     orderType: "LIMIT",
        #     securityId: "1001",
        #     quantity: 10,
        #     price: 150.0
        #   })
        def place(order_params)
          validated_params = validate_with(Dhanhq::Contracts::PlaceOrderContract, order_params)
          post("/orders", validated_params)
        end

        # Places an entry order.
        #
        # @param params [Hash] The order parameters (e.g., transactionType, exchangeSegment, etc.).
        # @return [Hash] The API response with order details.
        def entry(params)
          place(params)
        end

        # Places a stop-loss order.
        #
        # @param params [Hash] The order parameters for stop-loss (must include triggerPrice).
        # @return [Hash] The API response with order details.
        def stop_loss(params)
          params[:orderType] = "STOP_LOSS" unless params[:orderType]
          place(params)
        end

        # Places an exit position order.
        #
        # @param params [Hash] The order parameters to exit a position (e.g., transactionType: "SELL").
        # @return [Hash] The API response with order details.
        def exit(params)
          place(params)
        end

        # Slices a large order into smaller orders for better execution.
        #
        # @param params [Hash] The order parameters.
        # @param slice_size [Integer] The size of each slice (default: 100).
        # @return [Array<Hash>] An array of API responses for each slice.
        def slicing(params, slice_size: 100)
          total_quantity = params[:quantity].to_i
          raise ArgumentError, "Quantity must be greater than zero." if total_quantity <= 0

          responses = []
          while total_quantity.positive?
            slice_quantity = [slice_size, total_quantity].min
            params[:quantity] = slice_quantity
            responses << slicing_order(params)
            total_quantity -= slice_quantity
          end

          responses
        end

        # Modifies a pending order.
        #
        # @param order_id [String] The ID of the order to modify.
        # @param modify_params [Hash] The parameters for modifying the order.
        #   Required keys are validated using `ModifyOrderContract`.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Modify a pending order:
        #   modified_order = Orders.modify("order123", { price: 145.0, quantity: 5 })
        def modify(order_id, modify_params)
          validated_params = validate_with(Dhanhq::Contracts::ModifyOrderContract, modify_params)
          put("/orders/#{order_id}", validated_params)
        end

        # Cancels a pending order.
        #
        # @param order_id [String] The ID of the order to cancel.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Cancel a pending order:
        #   canceled_order = Orders.cancel("order123")
        def cancel(order_id)
          delete("/orders/#{order_id}")
        end

        # Places a sliced order.
        #
        # @param order_params [Hash] The parameters for placing the sliced order.
        #   Required keys are validated using `SliceOrderContract`.
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Place a sliced order:
        #   sliced_order = Orders.slicing_order({
        #     dhanClientId: "123456",
        #     transactionType: "SELL",
        #     exchangeSegment: "NSE_EQ",
        #     productType: "CNC",
        #     securityId: "1001",
        #     quantity: 100,
        #     price: 150.0
        #   })
        def slicing_order(order_params)
          validated_params = validate_with(Dhanhq::Contracts::SliceOrderContract, order_params)
          post("/orders/slicing", validated_params)
        end
      end
    end
  end
end
