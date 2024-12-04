# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module Funds
      # Validates the parameters required for calculating margin requirements for a trade.
      # Ensures that all fields are present and values are within the allowed range.
      class CalculateMarginValidator < Dry::Validation::Contract
        params do
          required(:dhanClientId).filled(:string)
          required(:exchangeSegment).filled(:string, included_in?: %w[NSE_EQ NSE_FNO BSE_EQ BSE_FNO MCX_COMM])
          required(:transactionType).filled(:string, included_in?: %w[BUY SELL])
          required(:quantity).filled(:integer, gt?: 0)
          required(:productType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN MTF CO BO])
          required(:securityId).filled(:string)
          required(:price).filled(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float)
        end
      end
    end
  end
end
