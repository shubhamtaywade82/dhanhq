# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module ForeverOrders
      # Validates the parameters required for creating a Forever Order.
      # Ensures all fields are present and meet the API's constraints.
      class CreateForeverOrderValidator < Dry::Validation::Contract
        params do
          required(:dhanClientId).filled(:string)
          required(:orderFlag).filled(:string, included_in?: %w[SINGLE OCO])
          required(:transactionType).filled(:string, included_in?: %w[BUY SELL])
          required(:exchangeSegment).filled(:string, included_in?: %w[NSE_EQ NSE_FNO BSE_EQ MCX_COMM])
          required(:productType).filled(:string, included_in?: %w[CNC MTF])
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET])
          required(:validity).filled(:string, included_in?: %w[DAY IOC])
          required(:securityId).filled(:string)
          required(:quantity).filled(:integer, gt?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float, gt?: 0)
          optional(:price1).maybe(:float, gt?: 0)
          optional(:triggerPrice1).maybe(:float, gt?: 0)
          optional(:quantity1).maybe(:integer, gt?: 0)
        end

        rule(:orderFlag, :price1) do
          key.failure("is required when orderFlag is OCO") if values[:orderFlag] == "OCO" && values[:price1].nil?
        end

        rule(:orderFlag, :triggerPrice1) do
          key.failure("is required when orderFlag is OCO") if values[:orderFlag] == "OCO" && values[:triggerPrice1].nil?
        end

        rule(:orderFlag, :quantity1) do
          key.failure("is required when orderFlag is OCO") if values[:orderFlag] == "OCO" && values[:quantity1].nil?
        end
      end
    end
  end
end
