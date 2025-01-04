# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for placing an order via Dhanhq's API.
    #
    # This contract validates the parameters required to place an order,
    # ensuring the correctness of inputs based on API requirements. It includes:
    # - Mandatory fields for order placement.
    # - Conditional validation for optional fields based on provided values.
    # - Validation of enumerated values using constants for consistency.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::PlaceOrderContract.new
    #   result = contract.call(
    #     dhanClientId: "123456",
    #     transactionType: "BUY",
    #     exchangeSegment: "NSE_EQ",
    #     productType: "CNC",
    #     orderType: "LIMIT",
    #     validity: "DAY",
    #     securityId: "1001",
    #     quantity: 10,
    #     price: 150.0
    #   )
    #   result.success? # => true or false
    #
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class PlaceOrderContract < BaseContract
      # Parameters and validation rules for the place order request.
      #
      # @!attribute [r] correlationId
      #   @return [String] Optional. Identifier for tracking, max length 25 characters.
      # @!attribute [r] transactionType
      #   @return [String] Required. BUY or SELL.
      # @!attribute [r] exchangeSegment
      #   @return [String] Required. Exchange segment for the order.
      #     Must be one of: `EXCHANGE_SEGMENTS`.
      # @!attribute [r] productType
      #   @return [String] Required. Product type for the order.
      #     Must be one of: `PRODUCT_TYPES`.
      # @!attribute [r] orderType
      #   @return [String] Required. Type of order.
      #     Must be one of: `ORDER_TYPES`.
      # @!attribute [r] validity
      #   @return [String] Required. Validity of the order.
      #     Must be one of: DAY, IOC.
      # @!attribute [r] tradingSymbol
      #   @return [String] Optional. Trading symbol of the instrument.
      # @!attribute [r] securityId
      #   @return [String] Required. Security identifier for the order.
      # @!attribute [r] quantity
      #   @return [Integer] Required. Quantity of the order, must be greater than 0.
      # @!attribute [r] disclosedQuantity
      #   @return [Integer] Optional. Disclosed quantity, must be >= 0 if provided.
      # @!attribute [r] price
      #   @return [Float] Optional. Price for the order, must be > 0 if provided.
      # @!attribute [r] triggerPrice
      #   @return [Float] Optional. Trigger price for stop-loss orders, must be > 0 if provided.
      # @!attribute [r] afterMarketOrder
      #   @return [Boolean] Optional. Indicates if this is an after-market order.
      # @!attribute [r] amoTime
      #   @return [String] Optional. Time for after-market orders. Must be one of: OPEN, OPEN_30, OPEN_60.
      # @!attribute [r] boProfitValue
      #   @return [Float] Optional. Profit value for Bracket Orders, must be > 0 if provided.
      # @!attribute [r] boStopLossValue
      #   @return [Float] Optional. Stop-loss value for Bracket Orders, must be > 0 if provided.
      # @!attribute [r] drvExpiryDate
      #   @return [String] Optional. Expiry date for derivative contracts.
      # @!attribute [r] drvOptionType
      #   @return [String] Optional. Option type for derivatives, must be one of: CALL, PUT, NA.
      # @!attribute [r] drvStrikePrice
      #   @return [Float] Optional. Strike price for options, must be > 0 if provided.
      params do
        optional(:correlationId).maybe(:string, max_size?: 25)
        required(:transactionType).filled(:string, included_in?: TRANSACTION_TYPES)
        required(:exchangeSegment).filled(:string, included_in?: EXCHANGE_SEGMENTS)
        required(:productType).filled(:string, included_in?: PRODUCT_TYPES)
        required(:orderType).filled(:string, included_in?: ORDER_TYPES)
        required(:validity).filled(:string, included_in?: VALIDITY_TYPES)
        optional(:tradingSymbol).maybe(:string)
        required(:securityId).filled(:string)
        required(:quantity).filled(:integer, gt?: 0)
        optional(:disclosedQuantity).maybe(:integer, gteq?: 0)
        optional(:price).maybe(:float, gt?: 0)
        optional(:triggerPrice).maybe(:float, gt?: 0)
        optional(:afterMarketOrder).maybe(:bool)
        optional(:amoTime).maybe(:string, included_in?: %w[OPEN OPEN_30 OPEN_60])
        optional(:boProfitValue).maybe(:float, gt?: 0)
        optional(:boStopLossValue).maybe(:float, gt?: 0)
        optional(:drvExpiryDate).maybe(:string)
        optional(:drvOptionType).maybe(:string, included_in?: %w[CALL PUT NA])
        optional(:drvStrikePrice).maybe(:float, gt?: 0)
      end

      # Custom validation for trigger price when the order type is STOP_LOSS or STOP_LOSS_MARKET.
      rule(:triggerPrice, :orderType) do
        if values[:orderType] =~ (/^STOP_LOSS/) && !values[:triggerPrice]
          key(:triggerPrice).failure("is required for orderType STOP_LOSS or STOP_LOSS_MARKET")
        end
      end

      # Custom validation for AMO time when the order is marked as after-market.
      rule(:afterMarketOrder, :amoTime) do
        if values[:afterMarketOrder] == true && !values[:amoTime]
          key(:amoTime).failure("is required when afterMarketOrder is true")
        end
      end

      # Custom validation for Bracket Order (BO) fields.
      rule(:boProfitValue, :boStopLossValue, :productType) do
        if values[:productType] == "BO" && (!values[:boProfitValue] || !values[:boStopLossValue])
          key(:boProfitValue).failure("is required for Bracket Orders")
          key(:boStopLossValue).failure("is required for Bracket Orders")
        end
      end
    end
  end
end
