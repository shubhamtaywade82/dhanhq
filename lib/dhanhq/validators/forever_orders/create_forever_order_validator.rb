# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module ForeverOrders
      # Validator for creating a Forever Order
      class CreateForeverOrderValidator < Dhanhq::Validators::BaseValidator
        params do
          required(:dhanClientId).filled(:string)
          optional(:correlationId).maybe(:string, max_size?: 25)
          required(:orderFlag).filled(:string, included_in?: %w[SINGLE OCO])
          required(:transactionType).filled(:string, included_in?: Dhanhq::Constants::TRANSACTION_TYPES)
          required(:exchangeSegment).filled(:string, included_in?: Dhanhq::Constants::EXCHANGE_SEGMENTS.keys)
          required(:productType).filled(:string, included_in?: %w[CNC MTF])
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET])
          required(:validity).filled(:string, included_in?: Dhanhq::Constants::VALIDITY_TYPES)
          required(:securityId).filled(:string)
          required(:quantity).filled(:integer, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gteq?: 0)
          required(:price).filled(:float, gt?: 0)
          required(:triggerPrice).filled(:float, gt?: 0)
          optional(:price1).maybe(:float, gt?: 0)
          optional(:triggerPrice1).maybe(:float, gt?: 0)
          optional(:quantity1).maybe(:integer, gt?: 0)
        end

        # Rule for `price1`, `triggerPrice1`, and `quantity1` when `orderFlag` is OCO
        rule(:orderFlag, :price1, :triggerPrice1, :quantity1) do
          if values[:orderFlag] == "OCO"
            key(:price1).failure("is required for OCO orders") if values[:price1].nil?
            key(:triggerPrice1).failure("is required for OCO orders") if values[:triggerPrice1].nil?
            key(:quantity1).failure("is required for OCO orders") if values[:quantity1].nil?
          end
        end
      end
    end
  end
end
