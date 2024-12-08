# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module Orders
      # Validator for placing a new order.
      class PlaceOrderValidator < Dhanhq::Validators::BaseValidator
        # Schema definition
        params do
          required(:dhanClientId).filled(:string)
          optional(:correlationId).maybe(:string, max_size?: 25)
          required(:transactionType).filled(:string, included_in?: Dhanhq::Constants::TRANSACTION_TYPES)
          required(:exchangeSegment).filled(:string, included_in?: Dhanhq::Constants::EXCHANGE_SEGMENTS.keys)
          required(:productType).filled(:string, included_in?: Dhanhq::Constants::PRODUCT_TYPES)
          required(:orderType).filled(:string, included_in?: Dhanhq::Constants::ORDER_TYPES)
          required(:validity).filled(:string, included_in?: Dhanhq::Constants::VALIDITY_TYPES)
          required(:securityId).filled(:string)
          required(:quantity).filled(:integer, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gteq?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float, gt?: 0)
          optional(:afterMarketOrder).maybe(:bool)
          optional(:amoTime).maybe(:string, included_in?: %w[OPEN OPEN_30 OPEN_60])
          optional(:boProfitValue).maybe(:float, gt?: 0)
          optional(:boStopLossValue).maybe(:float, gt?: 0)
        end

        # Rule for `triggerPrice` based on `orderType`
        rule(:orderType, :triggerPrice) do
          if %w[STOP_LOSS STOP_LOSS_MARKET].include?(values[:orderType]) &&
             (values[:triggerPrice].nil? || values[:triggerPrice] <= 0)
            key(:triggerPrice).failure("is required and must be greater than 0 for STOP_LOSS or STOP_LOSS_MARKET order types")
          end
        end

        # Rule for `price` required for `LIMIT` orderType
        rule(:orderType, :price) do
          if values[:orderType] == "LIMIT" && (values[:price].nil? || values[:price] <= 0)
            key(:price).failure("is required and must be greater than 0 for LIMIT order types")
          end
        end

        # Rule for `boProfitValue` and `boStopLossValue` for BO productType
        rule(:productType, :boProfitValue, :boStopLossValue) do
          if values[:productType] == "BO"
            if values[:boProfitValue].nil? || values[:boProfitValue] <= 0
              key(:boProfitValue).failure("must be greater than 0 for BO product type")
            end
            if values[:boStopLossValue].nil? || values[:boStopLossValue] <= 0
              key(:boStopLossValue).failure("must be greater than 0 for BO product type")
            end
          end
        end

        # Rule for `amoTime` required if `afterMarketOrder` is true
        rule(:afterMarketOrder, :amoTime) do
          if values[:afterMarketOrder] && values[:amoTime].nil?
            key(:amoTime).failure("is required when afterMarketOrder is true")
          end
        end
      end
    end
  end
end
