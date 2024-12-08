# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module Orders
      # Validator for modifying an existing order.
      class ModifyOrderValidator < Dhanhq::Validators::BaseValidator
        params do
          required(:dhanClientId).filled(:string)
          required(:orderId).filled(:string)
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
          optional(:legName).maybe(:string, included_in?: %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG])
          optional(:quantity).maybe(:integer, gt?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gt?: 0)
          optional(:triggerPrice).maybe(:float)
          required(:validity).filled(:string, included_in?: %w[DAY IOC])
        end

        # Rule for `triggerPrice` required for specific order types
        rule(:orderType, :triggerPrice) do
          if %w[STOP_LOSS STOP_LOSS_MARKET].include?(values[:orderType]) && values[:triggerPrice].nil?
            key(:triggerPrice).failure("is required for STOP_LOSS or STOP_LOSS_MARKET order types")
          end
        end

        # Rule for `legName` required when orderType is CO or BO
        rule(:orderType, :legName) do
          if %w[CO BO].include?(values[:orderType]) && values[:legName].nil?
            key.failure("is required for CO or BO order types")
          end
        end

        # Rule for at least one modifiable field
        rule(:quantity, :price, :triggerPrice, :disclosedQuantity) do
          if values[:quantity].nil? && values[:price].nil? && values[:triggerPrice].nil? && values[:disclosedQuantity].nil?
            key.failure("at least one of quantity, price, triggerPrice, or disclosedQuantity must be provided")
          end
        end
      end
    end
  end
end
