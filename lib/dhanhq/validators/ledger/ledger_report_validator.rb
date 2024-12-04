# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module Ledger
      # Validates the parameters for retrieving a ledger report.
      # Ensures that the date range is valid and follows the correct format.
      class LedgerReportValidator < Dry::Validation::Contract
        params do
          required(:from_date).filled(:string, format?: /^\d{4}-\d{2}-\d{2}$/)
          required(:to_date).filled(:string, format?: /^\d{4}-\d{2}-\d{2}$/)
        end

        rule(:from_date, :to_date) do
          key.failure("must be earlier than or equal to to_date") if values[:from_date] > values[:to_date]
        end
      end
    end
  end
end
