# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module Portfolio
      # Validates the parameters required for converting a position.
      # Ensures all fields are present and meet the API's constraints.
      class ConvertPositionValidator < Dry::Validation::Contract
        params do
          required(:dhanClientId).filled(:string)
          required(:fromProductType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN CO BO])
          required(:toProductType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN CO BO])
          required(:securityId).filled(:string)
          required(:convertQty).filled(:integer, gt?: 0)
        end

        rule(:fromProductType, :toProductType) do
          key.failure("must not be the same") if values[:fromProductType] == values[:toProductType]
        end
      end
    end
  end
end
