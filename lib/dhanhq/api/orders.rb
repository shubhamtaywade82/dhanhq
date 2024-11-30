# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles all endpoints related to orders, including order placement,
    # modification, cancellation, and fetching order/trade details.
    #
    # @example Place a new order:
    #   client = Dhanhq::Client.new
    #   orders = client.orders
    #   response = orders.place_order({ quantity: 5, price: 100.0, ... })
    #
    # @see https://api.dhan.co/documentation for API documentation
    class Orders < Base
      # Initializes the Orders API module
      #
      # @param client [Dhanhq::Client] The main client instance to make requests
      class << self
        # Place a new order
        #
        # @param params [Hash] The request payload for placing a new order
        # @return [Hash] The response from the API
        #
        # @example Place a new order:
        #   orders.place_order({
        #     dhanClientId: '1000000003',
        #     transactionType: 'BUY',
        #     exchangeSegment: 'NSE_EQ',
        #     productType: 'INTRADAY',
        #     orderType: 'MARKET',
        #     validity: 'DAY',
        #     securityId: '11536',
        #     quantity: 5
        #   })
        def place_order(params)
          request(:post, "/orders", params)
        end

        # Modify a pending order
        #
        # @param order_id [String] The ID of the order to be modified
        # @param params [Hash] The request payload for modification
        # @return [Hash] The response from the API
        #
        # @example Modify an order:
        #   orders.modify_order('112111182045', {
        #     price: 120.5,
        #     quantity: 10,
        #     orderType: 'LIMIT',
        #     validity: 'DAY'
        #   })
        def modify_order(order_id, params)
          request(:put, "/orders/#{order_id}", params)
        end

        # Cancel a pending order
        #
        # @param order_id [String] The ID of the order to be canceled
        # @return [Hash] The response from the API
        #
        # @example Cancel an order:
        #   orders.cancel_order('112111182045')
        def cancel_order(order_id)
          request(:delete, "/orders/#{order_id}")
        end

        # Place a slice order
        #
        # @param params [Hash] The request payload for placing a slice order
        # @return [Array<Hash>] The response from the API
        #
        # @example Place a slice order:
        #   orders.place_slice_order({
        #     dhanClientId: '1000000003',
        #     transactionType: 'BUY',
        #     exchangeSegment: 'NSE_EQ',
        #     productType: 'INTRADAY',
        #     orderType: 'MARKET',
        #     validity: 'DAY',
        #     securityId: '11536',
        #     quantity: 1000
        #   })
        def place_slice_order(params)
          request(:post, "/orders/slicing", params)
        end

        # Retrieve the list of all orders for the day
        #
        # @return [Array<Hash>] The list of orders
        #
        # @example Retrieve orders:
        #   Dhanhq::Api::Orders.orders_list
        def orders_list
          request(:get, "/orders")
        end

        # Retrieve the status of an order by its ID
        #
        # @param order_id [String] The ID of the order to retrieve
        # @return [Hash] The order details
        #
        # @example Get order by ID:
        #   orders.get_order_by_id('112111182198')
        def get_order_by_id(order_id)
          request(:get, "/orders/#{order_id}")
        end

        # Retrieve the status of an order by its correlation ID
        #
        # @param correlation_id [String] The correlation ID of the order
        # @return [Hash] The order details
        #
        # @example Get order by correlation ID:
        #   orders.get_order_by_correlation_id('123abc678')
        def get_order_by_correlation_id(correlation_id)
          request(:get, "/orders/external/#{correlation_id}")
        end

        # Retrieve the list of all trades for the day
        #
        # @return [Array<Hash>] The list of trades
        #
        # @example Retrieve trades:
        #   orders.trades_list
        def trades_list
          request(:get, "/trades")
        end

        # Retrieve the trade details of a specific order
        #
        # @param order_id [String] The ID of the order to retrieve trades
        # @return [Array<Hash>] The trade details
        #
        # @example Get trades by order ID:
        #   orders.get_trades_by_order_id('112111182045')
        def get_trades_by_order_id(order_id)
          request(:get, "/trades/#{order_id}")
        end
      end
    end
  end
end
