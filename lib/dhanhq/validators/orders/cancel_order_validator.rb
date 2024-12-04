# frozen_string_literal: true

module Dhanhq
  module Validators
    module Orders
      # Validates the parameters for cancelling an existing order.
      # Ensures the required fields, such as order ID, are provided and valid.
      class CancelOrderValidator < Dry::Validation::Contract
        params do
          required(:dhanClientId).filled(:string)
          required(:orderId).filled(:string)
        end
      end
    end
  end
end
