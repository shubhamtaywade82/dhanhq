# frozen_string_literal: true

module Dhanhq
  module Validators
    module Orders
      ModifyOrderSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        required(:orderId).filled(:str?)
        required(:orderType).filled(included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
        optional(:legName).maybe(included_in?: %w[ENTRY_LEG TARGET_LEG STOP_LOSS_LEG])
        optional(:quantity).maybe(:int?, gt?: 0)
        optional(:price).maybe(:float?, gt?: 0)
        optional(:disclosedQuantity).maybe(:int?, gt?: 0)
        optional(:triggerPrice).maybe(:float?)
        required(:validity).filled(included_in?: %w[DAY IOC])

        rule(trigger_price_required: %i[orderType triggerPrice]) do |order_type, trigger_price|
          order_type.included_in?(%w[STOP_LOSS STOP_LOSS_MARKET]).then(trigger_price.filled?)
        end
      end
    end
  end
end
