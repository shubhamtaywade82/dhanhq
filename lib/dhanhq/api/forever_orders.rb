# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles endpoints related to Forever Orders, including creation, modification,
    # cancellation, and retrieval of Forever Orders.
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
          validate_params!(params, Dhanhq::Validators::ForeverOrders::CreateForeverOrderSchema)
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
          params[:orderId] = order_id
          validate_field(order_id, :orderId)
          validate_params!(params, Dhanhq::Validators::ForeverOrders::ModifyForeverOrderSchema)
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
          validate_field(order_id, :orderId)
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

        private

        # Validates a single field
        #
        # @param value [String] The value to validate
        # @param field_name [Symbol] The field name for error reporting
        def validate_field(value, field_name)
          return if value.is_a?(String) && !value.strip.empty?

          raise Dhanhq::Errors::ValidationError,
                { field_name => "must be present and valid" }
        end
      end
    end
  end
end
