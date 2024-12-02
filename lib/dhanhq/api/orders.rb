# frozen_string_literal: true

module Dhanhq
  module Api
    class Orders < BaseApi
      class << self
        def place_order(params)
          Dhanhq::Validators::OrderValidator.validate(params)
          request(:post, "/orders", params)
        end

        def modify_order(order_id, params)
          params[:orderId] = order_id
          Dhanhq::Validators::OrderModificationValidator.validate(params)
          request(:put, "/orders/#{order_id}", params)
        end

        def cancel_order(order_id)
          request(:delete, "/orders/#{order_id}")
        end

        def place_slice_order(params)
          request(:post, "/orders/slicing", params)
        end

        def orders_list
          request(:get, "/orders")
        end

        def get_order_by_id(order_id)
          request(:get, "/orders/#{order_id}")
        end

        def get_order_by_correlation_id(correlation_id)
          request(:get, "/orders/external/#{correlation_id}")
        end

        def trades_list
          request(:get, "/trades")
        end

        def get_trades_by_order_id(order_id)
          request(:get, "/trades/#{order_id}")
        end
      end
    end
  end
end
