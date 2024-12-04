# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module ForeverOrders
      # Validates the parameters required for modifying an existing Forever Order.
      # Ensures the parameters adhere to API constraints for valid order modification.
      class ModifyForeverOrderValidator < Dry::Validation::Contract
        params do
          required(:dhanClientId).filled(:string)
          required(:orderId).filled(:string)
          required(:orderFlag).filled(:string, included_in?: %w[SINGLE OCO])
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET])
          required(:legName).filled(:string, included_in?: %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG])
          optional(:quantity).maybe(:integer, gt?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float)
          optional(:validity).maybe(:string, included_in?: %w[DAY IOC])
        end
      end
    end
  end
end
