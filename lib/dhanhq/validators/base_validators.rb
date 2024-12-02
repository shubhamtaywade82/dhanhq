# frozen_string_literal: true

module Dhanhq
  module Validators
    class BaseValidator
      def self.validate_presence(params, required_fields)
        missing = required_fields.reject { |field| params.key?(field) }
        raise ArgumentError, "Missing required fields: #{missing.join(", ")}" if missing.any?
      end

      def self.validate_inclusion(value, valid_values, field)
        return if valid_values.include?(value)

        raise ArgumentError, "#{field} must be one of #{valid_values}. Got: #{value}"
      end

      def self.validate_conditional(params, _field, condition:, message:)
        return if condition.call(params)

        raise ArgumentError, message
      end
    end
  end
end
