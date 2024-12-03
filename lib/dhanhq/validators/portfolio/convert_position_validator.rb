# frozen_string_literal: true

module Dhanhq
  module Validators
    module Portfolio
      ConvertPositionSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        required(:fromProductType).filled(included_in?: %w[CNC INTRADAY MARGIN CO BO])
        required(:toProductType).filled(included_in?: %w[CNC INTRADAY MARGIN CO BO])
        required(:securityId).filled(:str?)
        required(:convertQty).filled(:int?, gt?: 0)

        rule(product_type_change: %i[fromProductType toProductType]) do |from_product, to_product|
          from_product.not_eql?(to_product)
        end
      end
    end
  end
end
