# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module ForeverOrders
      # Validator for modifying a Forever Order
      class ModifyForeverOrderValidator < Dhanhq::Validators::BaseValidator
        params do
          required(:dhanClientId).filled(:string)
          required(:orderId).filled(:string)
          required(:orderFlag).filled(:string, included_in?: %w[SINGLE OCO])
          required(:orderType).filled(:string, included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
          required(:legName).filled(:string, included_in?: %w[ENTRY_LEG TARGET_LEG])
          required(:quantity).filled(:integer, gt?: 0)
          required(:price).filled(:float, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gteq?: 0)
          required(:triggerPrice).filled(:float, gt?: 0)
          required(:validity).filled(:string, included_in?: Dhanhq::Constants::VALIDITY_TYPES)
        end
      end
    end
  end
end
