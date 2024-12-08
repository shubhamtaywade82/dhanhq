# frozen_string_literal: true

module Dhanhq
  module Validators
    class BaseValidator < Dry::Validation::Contract
      # Common rules or macros for all validators
      def self.valid_transaction_type
        ->(type) { Dhanhq::Constants::TRANSACTION_TYPES.include?(type) }
      end

      def self.valid_exchange_segment
        ->(segment) { Dhanhq::Constants::EXCHANGE_SEGMENTS.include?(segment) }
      end

      def self.valid_product_type
        ->(type) { Dhanhq::Constants::PRODUCT_TYPES.include?(type) }
      end
    end
  end
end
