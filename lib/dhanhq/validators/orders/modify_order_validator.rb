# frozen_string_literal: true

module Dhanhq
  module Validators
    module Orders
      # Validates the parameters for modifying an existing order.
      # Ensures that the fields adhere to the API constraints and that conditional logic is satisfied.
      class ModifyOrderValidator < Dry::Validation::Contract
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

        rule(:orderType, :triggerPrice) do
          if values[:orderType].in?(%w[STOP_LOSS STOP_LOSS_MARKET]) && values[:triggerPrice].nil?
            key.failure("is required for STOP_LOSS or STOP_LOSS_MARKET order types")
          end
        end
      end
    end
  end
end
