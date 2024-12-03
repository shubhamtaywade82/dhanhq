# frozen_string_literal: true

module Dhanhq
  module Validators
    module ForeverOrders
      ModifyForeverOrderSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        required(:orderId).filled(:str?)
        required(:orderFlag).filled(included_in?: %w[SINGLE OCO])
        required(:orderType).filled(included_in?: %w[LIMIT MARKET])
        required(:legName).filled(included_in?: %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG])
        optional(:quantity).maybe(:int?, gt?: 0)
        optional(:price).maybe(:float?, gt?: 0)
        optional(:triggerPrice).maybe(:float?, gt?: 0)
        optional(:validity).maybe(included_in?: %w[DAY IOC])
      end
    end
  end
end
