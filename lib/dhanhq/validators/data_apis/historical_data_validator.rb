# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module DataApis
      class HistoricalDataValidator < Dry::Validation::Contract
        params do
          required(:symbol).filled(:string)
          required(:interval).filled(:string, included_in?: %w[1m 5m 15m 30m 1h 1d 1w 1M])
          required(:from).filled(:integer, gt?: 0)
          required(:to).filled(:integer, gt?: 0)
        end

        rule(:from, :to) do
          key.failure("must be before 'to'") if values[:from] >= values[:to]
        end
      end
    end
  end
end
