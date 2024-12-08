# frozen_string_literal: true

require_relative "base"
require_relative "../validators/orders/place_order_validator"
require_relative "../validators/orders/modify_order_validator"
require_relative "../validators/orders/place_slice_order_validator"

module Dhanhq
  module Api
    # API client for managing orders on Dhan.
    class Orders < Base
      class << self
        # Place a new order.
        #
        # @param params [Hash] The order placement parameters.
        # @option params [String] :dhanClientId (required) User-specific identification.
        # @option params [String] :correlationId User/partner-generated ID for tracking.
        # @option params [String] :transactionType (required) "BUY" or "SELL".
        # @option params [String] :exchangeSegment (required) Exchange segment, e.g., "NSE_EQ".
        # @option params [String] :productType (required) Product type, e.g., "CNC".
        # @option params [String] :orderType (required) Order type, e.g., "LIMIT".
        # @option params [String] :validity (required) Validity, e.g., "DAY".
        # @option params [String] :securityId (required) Security ID.
        # @option params [Integer] :quantity (required) Quantity of shares.
        # @return [Hash] The response containing the order ID and status.
        # @raise [Dhanhq::Errors::ValidationError] if validation fails.
        def place_order(params)
          validate(params, Dhanhq::Validators::Orders::PlaceOrderValidator)
          request(:post, Constants::ENDPOINTS[:orders], params)
        end

        # Modify an existing order.
        #
        # @param order_id [String] The ID of the order to modify.
        # @param params [Hash] The modification parameters.
        # @option params [String] :dhanClientId (required) User-specific identification.
        # @option params [String] :orderType (required) New order type, e.g., "LIMIT".
        # @option params [Integer] :quantity (optional) New quantity.
        # @option params [Float] :price (optional) New price.
        # @option params [String] :validity (required) New validity, e.g., "DAY".
        # @return [Hash] The response containing the modified order ID and status.
        # @raise [Dhanhq::Errors::ValidationError] if validation fails.
        def modify_order(order_id, params)
          validate(params, Dhanhq::Validators::Orders::ModifyOrderValidator)
          request(:put, "/orders/#{order_id}", params)
        end

        # Cancel an order.
        #
        # @param order_id [String] The ID of the order to cancel.
        # @return [Hash] The response containing the canceled order ID and status.
        def cancel_order(order_id)
          request(:delete, "/orders/#{order_id}")
        end

        # Slice an order into multiple legs.
        #
        # @param params [Hash] The slicing parameters.
        # @option params [String] :dhanClientId (required) User-specific identification.
        # @option params [String] :correlationId User/partner-generated ID for tracking.
        # @option params [String] :transactionType (required) "BUY" or "SELL".
        # @option params [String] :exchangeSegment (required) Exchange segment, e.g., "NSE_EQ".
        # @option params [String] :productType (required) Product type, e.g., "CNC".
        # @option params [String] :orderType (required) Order type, e.g., "LIMIT".
        # @option params [String] :validity (required) Validity, e.g., "DAY".
        # @option params [String] :securityId (required) Security ID.
        # @option params [Integer] :quantity (required) Quantity of shares.
        # @return [Array<Hash>] An array of responses for each sliced order.
        # @raise [Dhanhq::Errors::ValidationError] if validation fails.
        def slice_order(params)
          validate(params, Dhanhq::Validators::Orders::PlaceSliceOrderValidator)
          request(:post, "/orders/slicing", params)
        end

        # Retrieve all orders for the day.
        #
        # @return [Array<Hash>] An array of orders with their details.
        def order_book
          request(:get, "/orders")
        end

        # Retrieve details of an order by ID.
        #
        # @param order_id [String] The ID of the order.
        # @return [Hash] The details of the specified order.
        def order_details(order_id)
          request(:get, "/orders/#{order_id}")
        end

        # Retrieve details of an order by correlation ID.
        #
        # @param correlation_id [String] The correlation ID of the order.
        # @return [Hash] The details of the specified order.
        def order_by_correlation_id(correlation_id)
          request(:get, "/orders/external/#{correlation_id}")
        end

        # Retrieve all trades for the day.
        #
        # @return [Array<Hash>] An array of trades with their details.
        def trade_book
          request(:get, "/trades")
        end

        # Retrieve trade details by order ID.
        #
        # @param order_id [String] The ID of the order.
        # @return [Hash] The trade details for the specified order.
        def trade_details(order_id)
          request(:get, "/trades/#{order_id}")
        end
      end
    end
  end
end
