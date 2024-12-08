# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module Portfolio
      # Validator for converting a position
      class ConvertPositionValidator < Dhanhq::Validators::BaseValidator
        params do
          required(:dhanClientId).filled(:string)
          required(:fromProductType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN CO BO])
          required(:exchangeSegment).filled(:string, included_in?: Dhanhq::Constants::EXCHANGE_SEGMENTS.keys)
          required(:positionType).filled(:string, included_in?: %w[LONG SHORT CLOSED])
          required(:securityId).filled(:string)
          required(:convertQty).filled(:integer, gt?: 0)
          required(:toProductType).filled(:string, included_in?: %w[CNC INTRADAY MARGIN CO BO])
          optional(:tradingSymbol).maybe(:string)
        end

        # Rule to ensure fromProductType and toProductType are not the same
        rule(:fromProductType, :toProductType) do
          if values[:fromProductType] == values[:toProductType]
            key(:toProductType).failure("must be different from fromProductType")
          end
        end
      end
    end
  end
end
