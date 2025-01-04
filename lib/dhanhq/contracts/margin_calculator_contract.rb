# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for calculating margin requirements via Dhanhq's API.
    #
    # This contract ensures the correct structure and values for margin calculation requests,
    # including conditional rules based on the type of product.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::MarginCalculatorContract.new
    #   result = contract.call(
    #     dhanClientId: "123456",
    #     exchangeSegment: "NSE_FNO",
    #     transactionType: "BUY",
    #     quantity: 10,
    #     productType: "CNC",
    #     securityId: "1001",
    #     price: 150.0,
    #     triggerPrice: nil
    #   )
    #   result.success? # => true or false
    #
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class MarginCalculatorContract < BaseContract
      # Parameters and validation rules for the Margin Calculator request.
      #
      # @!attribute [r] dhanClientId
      #   @return [String] Required. Unique client identifier from Dhanhq.
      # @!attribute [r] exchangeSegment
      #   @return [String] Required. The exchange segment where the trade is placed.
      #     Must be one of:
      #     - NSE_EQ
      #     - NSE_FNO
      #     - NSE_CURRENCY
      #     - BSE_EQ
      #     - BSE_FNO
      #     - BSE_CURRENCY
      #     - MCX_COMM.
      # @!attribute [r] transactionType
      #   @return [String] Required. The type of transaction.
      #     Must be one of: BUY, SELL.
      # @!attribute [r] quantity
      #   @return [Integer] Required. Quantity of the trade, must be greater than 0.
      # @!attribute [r] productType
      #   @return [String] Required. Type of product.
      #     Must be one of: CNC, INTRADAY, MARGIN, MTF, CO, BO.
      # @!attribute [r] securityId
      #   @return [String] Required. Security identifier for the trade.
      # @!attribute [r] price
      #   @return [Float] Required. The price of the trade, must be greater than 0.
      # @!attribute [r] triggerPrice
      #   @return [Float] Optional. Trigger price for the trade, must be greater than 0 if provided.
      #
      #   @example Valid input:
      #     {
      #       exchangeSegment: "NSE_FNO",
      #       transactionType: "BUY",
      #       quantity: 10,
      #       productType: "CNC",
      #       securityId: "1001",
      #       price: 150.0,
      #       triggerPrice: nil
      #     }
      params do
        required(:exchangeSegment).filled(:string,
                                          included_in?: %w[NSE_EQ NSE_FNO NSE_CURRENCY BSE_EQ BSE_FNO BSE_CURRENCY
                                                           MCX_COMM])
        required(:transactionType).filled(:string, included_in?: %w[BUY SELL])
        required(:quantity).filled(:integer, gt?: 0)
        required(:productType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN MTF CO BO])
        required(:securityId).filled(:string)
        required(:price).filled(:float, gt?: 0)
        optional(:triggerPrice).maybe(:float, gt?: 0)
      end

      # Custom rule for conditionally required triggerPrice.
      #
      # @example Invalid input for STOP_LOSS product type:
      #   productType: "STOP_LOSS", triggerPrice: nil
      #   => Adds failure message "is required for productType STOP_LOSS or STOP_LOSS_MARKET".
      #
      # @param triggerPrice [Float] Trigger price for STOP_LOSS products.
      # @param productType [String] The type of product being traded.
      rule(:triggerPrice, :productType) do
        if values[:productType] =~ /^STOP_LOSS/ && !values[:triggerPrice]
          key(:triggerPrice).failure("is required for productType STOP_LOSS or STOP_LOSS_MARKET")
        end
      end
    end
  end
end
