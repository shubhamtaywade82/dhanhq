# frozen_string_literal: true

module Dhanhq
  module Validators
    module Orders
      CancelOrderSchema = Dry::Validation.Schema do
        required(:dhanClientId).filled(:str?)
        required(:orderId).filled(:str?)
      end
    end
  end
end
