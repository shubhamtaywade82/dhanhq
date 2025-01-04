# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for placing Forever Orders via Dhanhq's API.
    #
    # Forever Orders allow creating and managing persistent orders that remain
    # active until explicitly canceled or executed. This contract validates:
    # - Mandatory fields for both `SINGLE` and `OCO` orders.
    # - Conditional validations for `OCO`-specific fields.
    # - Consistency and range constraints for price-related fields.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::PlaceForeverOrderContract.new
    #   result = contract.call(
    #     dhanClientId: "123456",
    #     orderFlag: "OCO",
    #     transactionType: "BUY",
    #     exchangeSegment: "NSE_EQ",
    #     productType: "CNC",
    #     orderType: "LIMIT",
    #     validity: "DAY",
    #     securityId: "1001",
    #     quantity: 10,
    #     price: 150.0,
    #     triggerPrice: 140.0,
    #     price1: 130.0,
    #     triggerPrice1: 120.0,
    #     quantity1: 5
    #   )
    #   result.success? # => true or false
    #
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class PlaceForeverOrderContract < BaseContract
      # Parameters and validation rules for the Forever Order request.
      #
      # @!attribute [r] correlationId
      #   @return [String] Optional. Identifier for tracking, max length 25 characters.
      # @!attribute [r] orderFlag
      #   @return [String] Required. Indicates the order type:
      #     - SINGLE: Single-leg order.
      #     - OCO: One-cancels-the-other order.
      # @!attribute [r] transactionType
      #   @return [String] Required. BUY or SELL, validated using `TRANSACTION_TYPES`.
      # @!attribute [r] exchangeSegment
      #   @return [String] Required. Exchange segment for the order. Must be one of:
      #     NSE_EQ, NSE_FNO, BSE_EQ, BSE_FNO.
      # @!attribute [r] productType
      #   @return [String] Required. Product type for the order. Must be one of:
      #     CNC, MTF, MARGIN.
      # @!attribute [r] orderType
      #   @return [String] Required. Type of order. Must be one of:
      #     LIMIT, MARKET.
      # @!attribute [r] validity
      #   @return [String] Required. Validity of the order. Must be one of:
      #     DAY, IOC.
      # @!attribute [r] securityId
      #   @return [String] Required. Security identifier for the order.
      # @!attribute [r] quantity
      #   @return [Integer] Required. Quantity of the order, must be greater than 0.
      # @!attribute [r] disclosedQuantity
      #   @return [Integer] Optional. Disclosed quantity, must be > 0 if provided.
      # @!attribute [r] price
      #   @return [Float] Required. Price for the order, must be > 0.
      # @!attribute [r] triggerPrice
      #   @return [Float] Required. Trigger price for the order, must be > 0.
      # @!attribute [r] price1
      #   @return [Float] Optional. Price for the secondary leg in OCO orders.
      #     Required when `orderFlag` is OCO, must be > 0.
      # @!attribute [r] triggerPrice1
      #   @return [Float] Optional. Trigger price for the secondary leg in OCO orders.
      #     Required when `orderFlag` is OCO, must be > 0 and less than `price1`.
      # @!attribute [r] quantity1
      #   @return [Integer] Optional. Quantity for the secondary leg in OCO orders.
      #     Required when `orderFlag` is OCO, must be > 0.
      params do
        optional(:correlationId).maybe(:string, max_size?: 25)
        required(:orderFlag).filled(:string, included_in?: %w[SINGLE OCO])
        required(:transactionType).filled(:string, included_in?: TRANSACTION_TYPES)
        required(:exchangeSegment).filled(:string, included_in?: %w[NSE_EQ NSE_FNO BSE_EQ BSE_FNO])
        required(:productType).filled(:string, included_in?: %w[CNC MTF MARGIN])
        required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET])
        required(:validity).filled(:string, included_in?: %w[DAY IOC])
        required(:securityId).filled(:string)
        required(:quantity).filled(:integer, gt?: 0)
        optional(:disclosedQuantity).maybe(:integer, gt?: 0)
        required(:price).filled(:float, gt?: 0)
        required(:triggerPrice).filled(:float, gt?: 0)
        optional(:price1).maybe(:float, gt?: 0)
        optional(:triggerPrice1).maybe(:float, gt?: 0)
        optional(:quantity1).maybe(:integer, gt?: 0)
      end

      # Custom validation for OCO orders to ensure all secondary leg fields are present.
      #
      # @example Invalid OCO order:
      #   orderFlag: "OCO", price1: 100.0, triggerPrice1: nil, quantity1: 10
      #   => Adds failure message "price1, triggerPrice1, and quantity1 are required for OCO orders".
      #
      # @param orderFlag [String] The type of order.
      # @param price1 [Float] The secondary price for OCO orders.
      # @param triggerPrice1 [Float] The secondary trigger price for OCO orders.
      # @param quantity1 [Integer] The secondary quantity for OCO orders.
      rule(:orderFlag, :price1, :triggerPrice1, :quantity1) do
        if values[:orderFlag] == "OCO" && !(values[:price1] && values[:triggerPrice1] && values[:quantity1])
          key.failure("price1, triggerPrice1, and quantity1 are required for OCO orders")
        end
      end

      # Custom validation to ensure triggerPrice1 < price1 for OCO orders.
      #
      # @example Invalid OCO order:
      #   orderFlag: "OCO", price1: 120.0, triggerPrice1: 130.0
      #   => Adds failure message "triggerPrice1 must be less than price1 for OCO orders".
      #
      # @param price1 [Float] The secondary price for OCO orders.
      # @param triggerPrice1 [Float] The secondary trigger price for OCO orders.
      rule(:price1, :triggerPrice1) do
        if values[:orderFlag] == "OCO" &&
           values[:price1] && values[:triggerPrice1] &&
           values[:triggerPrice1] >= values[:price1]
          key(:triggerPrice1).failure("must be less than price1 for OCO orders")
        end
      end
    end
  end
end
