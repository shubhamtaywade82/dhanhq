# frozen_string_literal: true

require_relative "../base_validator"

module Dhanhq
  module Validators
    module ForeverOrders
      # Validator for canceling a Forever Order
      class CancelForeverOrderValidator < Dhanhq::Validators::BaseValidator
        params do
          required(:orderId).filled(:string)
        end
      end
    end
  end
end
