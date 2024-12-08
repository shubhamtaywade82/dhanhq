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
          optional(:correlationId).maybe(:string, max_size?: 25)
          required(:transactionType).filled(:string, included_in?: %w[BUY SELL])
          required(:exchangeSegment).filled(:string,
                                            included_in?: %w[NSE_EQ NSE_FNO NSE_CURRENCY BSE_EQ BSE_FNO BSE_CURRENCY
                                                             MCX_COMM])
          required(:productType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN MTF CO BO])
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
          required(:validity).filled(:string, included_in?: %w[DAY IOC])
          required(:securityId).filled(:string)
          required(:quantity).filled(:integer, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gteq?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float, gt?: 0)
          optional(:afterMarketOrder).maybe(:bool)
          optional(:amoTime).maybe(:string, included_in?: %w[OPEN OPEN_30 OPEN_60 PRE_OPEN])
          optional(:boProfitValue).maybe(:float, gt?: 0)
          optional(:boStopLossValue).maybe(:float, gt?: 0)
        end

        # Rule for `triggerPrice` required for specific order types
        rule(:orderType, :triggerPrice) do
          if %w[STOP_LOSS
                STOP_LOSS_MARKET].include?(values[:orderType]) && (values[:triggerPrice].nil? || values[:triggerPrice] <= 0)
            key.failure("is required and must be greater than 0 for STOP_LOSS or STOP_LOSS_MARKET order types")
          end
        end

        # Rule for `amoTime` required if `afterMarketOrder` is true
        rule(:afterMarketOrder, :amoTime) do
          key.failure("is required when afterMarketOrder is true") if values[:afterMarketOrder] && values[:amoTime].nil?
        end

        # Rule to ensure valid combinations for `productType` and `orderType`
        rule(:productType, :orderType) do
          if %w[CO BO].include?(values[:productType]) && !%w[LIMIT MARKET].include?(values[:orderType])
            key.failure("must be LIMIT or MARKET for CO and BO product types")
          end
        end

        # Rule to ensure `price` is required for `LIMIT` order type
        rule(:orderType, :price) do
          if values[:orderType] == "LIMIT" && (values[:price].nil? || values[:price] <= 0)
            key.failure("is required and must be greater than 0 for LIMIT order types")
          end
        end

        # Rule to ensure `boProfitValue` and `boStopLossValue` are valid for `BO` product type
        rule(:productType, :boProfitValue, :boStopLossValue) do
          if values[:productType] == "BO"
            if values[:boProfitValue].nil? || values[:boProfitValue] <= 0
              key.failure("boProfitValue must be greater than 0")
            end
            if values[:boStopLossValue].nil? || values[:boStopLossValue] <= 0
              key.failure("boStopLossValue must be greater than 0")
            end
          end
        end

        # Rule to ensure `disclosedQuantity` does not exceed `quantity`
        rule(:quantity, :disclosedQuantity) do
          if values[:disclosedQuantity] && values[:disclosedQuantity] > values[:quantity]
            key.failure("cannot exceed the total quantity")
          end
        end
      end
    end
  end
end
