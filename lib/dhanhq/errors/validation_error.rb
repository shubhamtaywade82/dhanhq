# frozen_string_literal: true

module Dhanhq
  module Errors
    # Raised for validation errors
    class ValidationError < ApiError
      def initialize(errors = {})
        formatted_message = "Validation failed with errors: #{errors.inspect}"
        super(formatted_message, nil, errors)
      end
    end
  end
end
