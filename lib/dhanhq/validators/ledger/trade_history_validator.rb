# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module Ledger
      # Validates the parameters for retrieving historical trade data.
      # Ensures the date range is valid and the page number is non-negative.
      class TradeHistoryValidator < Dry::Validation::Contract
        params do
          required(:from_date).filled(:string, format?: /^\d{4}-\d{2}-\d{2}$/)
          required(:to_date).filled(:string, format?: /^\d{4}-\d{2}-\d{2}$/)
          required(:page).filled(:integer, gteq?: 0)
        end

        rule(:from_date, :to_date) do
          key.failure("must be earlier than or equal to to_date") if values[:from_date] > values[:to_date]
        end
      end
    end
  end
end
