# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module Orders
      # Validator for placing a slice order.
      class PlaceSliceOrderValidator < Dhanhq::Validators::BaseValidator
        # Schema definition
        params do
          required(:dhanClientId).filled(:string)
          optional(:correlationId).maybe(:string, max_size?: 25)
          required(:transactionType).filled(:string, included_in?: Dhanhq::Constants::TRANSACTION_TYPES)
          required(:exchangeSegment).filled(:string, included_in?: Dhanhq::Constants::EXCHANGE_SEGMENTS.keys)
          required(:productType).filled(:string, included_in?: Dhanhq::Constants::PRODUCT_TYPES)
          required(:orderType).filled(:string, included_in?: Dhanhq::Constants::ORDER_TYPES)
          required(:validity).filled(:string, included_in?: Dhanhq::Constants::VALIDITY_TYPES)
          required(:securityId).filled(:string)
          required(:quantity).filled(:integer, gt?: 0)
          optional(:disclosedQuantity).maybe(:integer, gteq?: 0)
          optional(:price).maybe(:float, gt?: 0)
          optional(:triggerPrice).maybe(:float, gt?: 0)
        end

        # Rule for `triggerPrice` required for specific order types
        rule(:orderType, :triggerPrice) do
          if %w[STOP_LOSS STOP_LOSS_MARKET].include?(values[:orderType]) &&
             (values[:triggerPrice].nil? || values[:triggerPrice] <= 0)
            key(:triggerPrice).failure("is required and must be greater than 0 for STOP_LOSS or STOP_LOSS_MARKET order types")
          end
        end

        # Rule for `price` required for LIMIT orderType
        rule(:orderType, :price) do
          if values[:orderType] == "LIMIT" && (values[:price].nil? || values[:price] <= 0)
            key(:price).failure("is required and must be greater than 0 for LIMIT order types")
          end
        end

        # Rule to ensure `disclosedQuantity` does not exceed `quantity`
        rule(:quantity, :disclosedQuantity) do
          if values[:disclosedQuantity] && values[:disclosedQuantity] > values[:quantity]
            key(:disclosedQuantity).failure("cannot exceed the total quantity")
          end
        end
      end
    end
  end
end
