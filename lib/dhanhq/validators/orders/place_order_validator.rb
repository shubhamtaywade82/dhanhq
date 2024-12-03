# frozen_string_literal: true

module Dhanhq
  module Validators
    module Orders
      PlaceOrderSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        optional(:correlationId).maybe(:str?)
        required(:transactionType).filled(included_in?: %w[BUY SELL])
        required(:exchangeSegment).filled(included_in?: %w[NSE_EQ NSE_FNO BSE_EQ MCX_COMM])
        required(:productType).filled(included_in?: %w[CNC INTRADAY MARGIN MTF CO BO])
        required(:orderType).filled(included_in?: %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET])
        required(:validity).filled(included_in?: %w[DAY IOC])
        required(:securityId).filled(:str?)
        required(:quantity).filled(:int?, gt?: 0)
        optional(:disclosedQuantity).maybe(:int?, gt?: 0)
        optional(:price).maybe(:float?, gt?: 0)
        optional(:triggerPrice).maybe(:float?)
        optional(:afterMarketOrder).maybe(:bool?)
        optional(:amoTime).maybe(included_in?: %w[OPEN OPEN_30 OPEN_60])
        optional(:boProfitValue).maybe(:float?)
        optional(:boStopLossValue).maybe(:float?)

        rule(trigger_price_required: %i[orderType triggerPrice]) do |order_type, trigger_price|
          order_type.included_in?(%w[STOP_LOSS STOP_LOSS_MARKET]).then(trigger_price.filled?)
        end

        rule(amo_time_required: %i[afterMarketOrder amoTime]) do |after_market_order, amo_time|
          after_market_order.true?.then(amo_time.filled?)
        end
      end
    end
  end
end
