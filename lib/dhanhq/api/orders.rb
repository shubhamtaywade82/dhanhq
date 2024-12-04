# frozen_string_literal: true

require_relative "../validators/orders/place_order_validator"
require_relative "../validators/orders/modify_order_validator"

module Dhanhq
  module Api
    # Handles API requests related to orders, including:
    # - Placing a new order
    # - Modifying a pending order
    # - Cancelling an order
    # - Retrieving order details
    class Orders < BaseApi
      class << self
        # Place a new order
        def place_order(params)
          validate_params(params, Dhanhq::Validators::Orders::PlaceOrderSchema)
          request(:post, "/orders", params)
        end

        # Modify an existing order
        def modify_order(order_id, params)
          params[:orderId] = order_id
          validate_params(params, Dhanhq::Validators::Orders::ModifyOrderSchema)
          request(:put, "/orders/#{order_id}", params)
        end

        # Cancel a pending order
        def cancel_order(order_id)
          validate_field(order_id, :orderId)
          request(:delete, "/orders/#{order_id}")
        end

        # Place a slicing order
        def place_slice_order(params)
          validate_params(params, Dhanhq::Validators::Orders::PlaceOrderSchema) # Reuses the PlaceOrderSchema
          request(:post, "/orders/slicing", params)
        end

        # Retrieve the list of all orders
        def orders_list
          request(:get, "/orders")
        end

        # Retrieve order details by order ID
        def get_order_by_id(order_id)
          validate_field(order_id, :orderId)
          request(:get, "/orders/#{order_id}")
        end

        # Retrieve order details by correlation ID
        def get_order_by_correlation_id(correlation_id)
          validate_field(correlation_id, :correlationId)
          request(:get, "/orders/external/#{correlation_id}")
        end

        # Retrieve the list of all trades
        def trades_list
          request(:get, "/trades")
        end

        # Retrieve trades by order ID
        def get_trades_by_order_id(order_id)
          validate_field(order_id, :orderId)
          request(:get, "/trades/#{order_id}")
        end

        private

        # Validates a single field
        #
        # @param value [String] The value to validate
        # @param field_name [Symbol] The field name for error reporting
        def validate_field(value, field_name)
          return if value.is_a?(String) && !value.strip.empty?

          raise Dhanhq::Errors::ValidationError, { field_name => "must be present and valid" }
        end
      end
    end
  end
end
