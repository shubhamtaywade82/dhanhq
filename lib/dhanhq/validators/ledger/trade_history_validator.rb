# frozen_string_literal: true

module Dhanhq
  module Validators
    module Ledger
      TradeHistorySchema = Dry::Validation.Schema do
        required(:from_date).filled(:str?, format?: /^\d{4}-\d{2}-\d{2}$/)
        required(:to_date).filled(:str?, format?: /^\d{4}-\d{2}-\d{2}$/)
        required(:page).filled(:int?, gteq?: 0)

        rule(valid_date_range: %i[from_date to_date]) do |from_date, to_date|
          from_date.lteq?(to_date)
        end
      end
    end
  end
end
