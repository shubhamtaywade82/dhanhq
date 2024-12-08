# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module Funds
      # Validator for the Margin Calculator endpoint
      class MarginCalculatorValidator < Dhanhq::Validators::BaseValidator
        params do
          required(:dhanClientId).filled(:string)
          required(:exchangeSegment).filled(:string, included_in?: Dhanhq::Constants::EXCHANGE_SEGMENTS.keys)
          required(:transactionType).filled(:string, included_in?: Dhanhq::Constants::TRANSACTION_TYPES)
          required(:quantity).filled(:integer, gt?: 0)
          required(:productType).filled(:string, included_in?: Dhanhq::Constants::PRODUCT_TYPES)
          required(:securityId).filled(:string)
          required(:price).filled(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float, gt?: 0)
        end

        # # Some issue with the triggerPrice
        # # Rule for `triggerPrice` based on `transactionType`
        # rule(:transactionType, :triggerPrice) do
        #   if %w[STOP_LOSS STOP_LOSS_MARKET].include?(values[:transactionType])
        #     if values[:triggerPrice].nil?
        #       key(:triggerPrice).failure("is required for STOP_LOSS or STOP_LOSS_MARKET transaction types")
        #     elsif values[:triggerPrice] <= 0
        #       key(:triggerPrice).failure("must be greater than 0 for STOP_LOSS or STOP_LOSS_MARKET transaction types")
        #     end
        #   end
        # end
      end
    end
  end
end
