# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module Orders
      # Validator for validating parameters required for placing a slice order.
      # Ensures all required fields are present and properly formatted.
      class PlaceSliceOrderValidator < Dry::Validation::Contract
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

        # Rule for amoTime required if afterMarketOrder is true
        rule(:afterMarketOrder, :amoTime) do
          key.failure("is required when afterMarketOrder is true") if values[:afterMarketOrder] && values[:amoTime].nil?
        end
      end
    end
  end
end
