# frozen_string_literal: true

require_relative "../contracts/place_super_order_contract"
require_relative "../contracts/modify_super_order_contract"
require_relative "../contracts/cancel_super_order_contract"

module Dhanhq
  module API
    # Provides methods to manage Super Orders via Dhanhq's Super Order API.
    #
    # @see Dhanhq::API::Base For shared HTTP methods & validation helper.
    # @see Dhanhq::Contracts::PlaceSuperOrderContract
    # @see Dhanhq::Contracts::ModifySuperOrderContract
    # @see Dhanhq::Contracts::CancelSuperOrderContract
    class SuperOrders < Base
      class << self
        # Retrieve all super orders for the current day.
        # @return [Array<Hash>]
        def list
          get("/v2/super/orders")
        end

        # Place a new super order.
        # @param params [Hash] see PlaceSuperOrderContract for required keys.
        # @return [Hash]
        def place(params)
          validated = validate_with(Dhanhq::Contracts::PlaceSuperOrderContract, params)
          post("/v2/super/orders", validated)
        end

        # Modify an existing super order (or its TARGET/STOP_LOSS legs).
        # @param order_id [String]
        # @param params [Hash] see ModifySuperOrderContract
        # @return [Hash]
        def modify(order_id, params)
          validated = validate_with(Dhanhq::Contracts::ModifySuperOrderContract, params.merge(orderId: order_id))
          put("/v2/super/orders/#{order_id}", validated)
        end

        # Cancel a pending super order (full or single leg).
        # @param order_id [String]
        # @param leg_name [String] one of ENTRY_LEG, TARGET_LEG, STOP_LOSS_LEG
        # @return [Hash]
        def cancel(order_id, leg_name = nil)
          params = { orderLeg: leg_name }.compact
          validated = validate_with(Dhanhq::Contracts::CancelSuperOrderContract, params.merge(orderId: order_id))
          delete("/v2/super/orders/#{order_id}/#{validated[:orderLeg]}")
        end
      end
    end
  end
end
