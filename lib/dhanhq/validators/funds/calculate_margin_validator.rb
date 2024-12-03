# frozen_string_literal: true

module Dhanhq
  module Validators
    module Funds
      CalculateMarginSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        required(:exchangeSegment).filled(included_in?: %w[NSE_EQ NSE_FNO BSE_EQ BSE_FNO MCX_COMM])
        required(:transactionType).filled(included_in?: %w[BUY SELL])
        required(:quantity).filled(:int?, gt?: 0)
        required(:productType).filled(included_in?: %w[CNC INTRADAY MARGIN MTF CO BO])
        required(:securityId).filled(:str?)
        required(:price).filled(:float?, gt?: 0)
        optional(:triggerPrice).maybe(:float?)
      end
    end
  end
end
