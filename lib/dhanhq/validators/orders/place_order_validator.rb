# frozen_string_literal: true

module Dhanhq
  module Validators
    module Orders
      # Validator for validating parameters required for placing an order.
      # Ensures all required fields are present and properly formatted.
      class PlaceOrderValidator < Dry::Validation::Contract
        # Define schema for the Place Order request
        params do
          required(:dhanClientId).filled(:string)
          optional(:correlationId).maybe(:string)
          required(:transactionType).filled(:string, included_in?: %w[BUY SELL])
          required(:exchangeSegment).filled(:string, included_in?: %w[NSE_EQ NSE_FNO BSE_EQ MCX_COMM])
          required(:productType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN MTF CO BO])
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
          required(:validity).filled(:string, included_in?: %w[DAY IOC])
          required(:securityId).filled(:string)
          required(:quantity).filled(:integer, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gt?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float)
          optional(:afterMarketOrder).maybe(:bool)
          optional(:amoTime).maybe(:string, included_in?: %w[OPEN OPEN_30 OPEN_60])
          optional(:boProfitValue).maybe(:float)
          optional(:boStopLossValue).maybe(:float)
        end

        # Rule for triggerPrice required for specific orderTypes
        rule(:orderType, :triggerPrice) do
          if values[:orderType].in?(%w[STOP_LOSS STOP_LOSS_MARKET]) && values[:triggerPrice].nil?
            key.failure("is required for STOP_LOSS or STOP_LOSS_MARKET order types")
          end
        end

        # Rule for amoTime required if afterMarketOrder is true
        rule(:afterMarketOrder, :amoTime) do
          key.failure("is required when afterMarketOrder is true") if values[:afterMarketOrder] && values[:amoTime].nil?
        end
      end
    end
  end
end
