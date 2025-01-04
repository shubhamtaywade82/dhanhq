# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for modifying Forever Orders via Dhanhq's API.
    #
    # This contract validates input parameters required for modifying Forever Orders.
    # It ensures correct values for single-leg (`SINGLE`) or one-cancels-the-other (`OCO`) orders
    # and applies specific rules for OCO orders.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::ModifyForeverOrderContract.new
    #   result = contract.call(
    #     dhanClientId: "123456",
    #     orderId: "1001",
    #     orderFlag: "OCO",
    #     orderType: "LIMIT",
    #     legName: "STOP_LOSS_LEG",
    #     quantity: 10,
    #     price: 150.0,
    #     triggerPrice: 140.0,
    #     validity: "DAY"
    #   )
    #   result.success? # => true or false
    #
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class ModifyForeverOrderContract < BaseContract
      # Parameters and validation rules for modifying Forever Orders.
      #
      # @!attribute [r] orderId
      #   @return [String] Required. Unique identifier for the order to be modified.
      # @!attribute [r] orderFlag
      #   @return [String] Required. Indicates the type of order:
      #     - SINGLE: Single-leg order.
      #     - OCO: One-cancels-the-other order.
      # @!attribute [r] orderType
      #   @return [String] Required. The type of order to modify.
      #     Must be one of: LIMIT, MARKET, STOP_LOSS, STOP_LOSS_MARKET.
      # @!attribute [r] legName
      #   @return [String] Required. The leg of the order to modify.
      #     Must be one of: TARGET_LEG, STOP_LOSS_LEG.
      # @!attribute [r] quantity
      #   @return [Integer] Required. Quantity to modify, must be greater than 0.
      # @!attribute [r] price
      #   @return [Float] Required. The price for the modification, must be greater than 0.
      # @!attribute [r] disclosedQuantity
      #   @return [Integer] Optional. The disclosed quantity, must be greater than or equal to 0.
      # @!attribute [r] triggerPrice
      #   @return [Float] Required. The trigger price for the modification, must be greater than 0.
      # @!attribute [r] validity
      #   @return [String] Required. Validity of the order.
      #     Must be one of: DAY, IOC.
      params do
        required(:orderId).filled(:string)
        required(:orderFlag).filled(:string, included_in?: %w[SINGLE OCO])
        required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
        required(:legName).filled(:string, included_in?: %w[TARGET_LEG STOP_LOSS_LEG])
        required(:quantity).filled(:integer, gt?: 0)
        required(:price).filled(:float, gt?: 0)
        optional(:disclosedQuantity).maybe(:integer, gt?: 0)
        required(:triggerPrice).filled(:float, gt?: 0)
        required(:validity).filled(:string, included_in?: %w[DAY IOC])
      end

      # Custom validation for `OCO` orders to ensure correct legName is provided.
      #
      # @example Invalid OCO order:
      #   orderFlag: "OCO", legName: "INVALID_LEG"
      #   => Adds failure message "must be STOP_LOSS_LEG or TARGET_LEG for OCO orders".
      #
      # @param orderFlag [String] The type of the order.
      # @param legName [String] The leg of the order to modify.
      rule(:orderFlag, :legName) do
        if values[:orderFlag] == "OCO" && !%w[STOP_LOSS_LEG TARGET_LEG].include?(values[:legName])
          key(:legName).failure("must be STOP_LOSS_LEG or TARGET_LEG for OCO orders")
        end
      end
    end
  end
end
