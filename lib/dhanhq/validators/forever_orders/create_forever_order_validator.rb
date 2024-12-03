# frozen_string_literal: true

module Dhanhq
  module Validators
    module ForeverOrders
      CreateForeverOrderSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        required(:orderFlag).filled(included_in?: %w[SINGLE OCO])
        required(:transactionType).filled(included_in?: %w[BUY SELL])
        required(:exchangeSegment).filled(included_in?: %w[NSE_EQ NSE_FNO BSE_EQ MCX_COMM])
        required(:productType).filled(included_in?: %w[CNC MTF])
        required(:orderType).filled(included_in?: %w[LIMIT MARKET])
        required(:validity).filled(included_in?: %w[DAY IOC])
        required(:securityId).filled(:str?)
        required(:quantity).filled(:int?, gt?: 0)
        optional(:price).maybe(:float?, gt?: 0)
        optional(:triggerPrice).maybe(:float?, gt?: 0)
        optional(:price1).maybe(:float?, gt?: 0)
        optional(:triggerPrice1).maybe(:float?, gt?: 0)
        optional(:quantity1).maybe(:int?, gt?: 0)

        rule(price1_required: %i[orderFlag price1]) do |order_flag, price1|
          order_flag.eql?("OCO").then(price1.filled?)
        end

        rule(trigger_price1_required: %i[orderFlag triggerPrice1]) do |order_flag, trigger_price1|
          order_flag.eql?("OCO").then(trigger_price1.filled?)
        end

        rule(quantity1_required: %i[orderFlag quantity1]) do |order_flag, quantity1|
          order_flag.eql?("OCO").then(quantity1.filled?)
        end
      end
    end
  end
end
