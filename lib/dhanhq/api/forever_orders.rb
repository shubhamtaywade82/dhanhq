# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles endpoints related to Forever Orders, including creation, modification,
    # cancellation, and retrieval of Forever Orders.
    #
    # @example Create a new Forever Order:
    #   client = Dhanhq::Client.new
    #   forever_orders = client.forever_orders
    #   response = forever_orders.create_forever_order({
    #     dhanClientId: '1000000132',
    #     orderFlag: 'SINGLE',
    #     transactionType: 'BUY',
    #     exchangeSegment: 'NSE_EQ',
    #     productType: 'CNC',
    #     orderType: 'LIMIT',
    #     validity: 'DAY',
    #     securityId: '1333',
    #     quantity: 5,
    #     price: 1428,
    #     triggerPrice: 1427
    #   })
    class ForeverOrders < Base
      class << self
        # Create a new Forever Order
        #
        # @param params [Hash] The request payload for creating a Forever Order
        # @return [Hash] The response from the API
        #
        # @example Create a Forever Order:
        #   forever_orders.create_forever_order({
        #     dhanClientId: '1000000132',
        #     orderFlag: 'SINGLE',
        #     transactionType: 'BUY',
        #     exchangeSegment: 'NSE_EQ',
        #     productType: 'CNC',
        #     orderType: 'LIMIT',
        #     validity: 'DAY',
        #     securityId: '1333',
        #     quantity: 5,
        #     price: 1428,
        #     triggerPrice: 1427
        #   })
        def create_forever_order(params)
          request(:post, "/forever/orders", params)
        end

        # Modify an existing Forever Order
        #
        # @param order_id [String] The ID of the Forever Order to be modified
        # @param params [Hash] The request payload for modifying the Forever Order
        # @return [Hash] The response from the API
        #
        # @example Modify a Forever Order:
        #   forever_orders.modify_forever_order('5132208051112', {
        #     dhanClientId: '1000000132',
        #     orderFlag: 'SINGLE',
        #     orderType: 'LIMIT',
        #     legName: 'ENTRY_LEG',
        #     quantity: 10,
        #     price: 1421,
        #     triggerPrice: 1420
        #   })
        def modify_forever_order(order_id, params)
          request(:put, "/forever/orders/#{order_id}", params)
        end

        # Cancel a Forever Order
        #
        # @param order_id [String] The ID of the Forever Order to be canceled
        # @return [Hash] The response from the API
        #
        # @example Cancel a Forever Order:
        #   forever_orders.cancel_forever_order('5132208051112')
        def cancel_forever_order(order_id)
          request(:delete, "/forever/orders/#{order_id}")
        end

        # Retrieve all existing Forever Orders
        #
        # @return [Array<Hash>] An array of Forever Orders
        #
        # @example Retrieve Forever Orders:
        #   forever_orders.get_forever_orders
        def forever_orders
          request(:get, "/forever/orders")
        end
      end
    end
  end
end
