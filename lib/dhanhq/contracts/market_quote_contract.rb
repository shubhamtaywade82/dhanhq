# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for fetching market quotes via Dhanhq's API.
    #
    # This contract validates input for the Market Quote API.
    # It ensures that:
    # - Data contains valid exchange segments as keys.
    # - Each segment has a non-empty array of security IDs as values.
    # - Security IDs in the arrays are integers.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::MarketQuoteContract.new
    #   result = contract.call(
    #     data: {
    #       "NSE_EQ" => [12345, 67890],
    #       "BSE_EQ" => [11223]
    #     }
    #   )
    #   result.success? # => true or false
    class MarketQuoteContract < BaseContract
      EXCHANGE_SEGMENTS = %w[IDX_I NSE_EQ NSE_FNO BSE_EQ BSE_FNO].freeze

      # Parameters and validation rules for the Market Quote request.
      params do
        required(:data).value(:hash)
      end

      rule(:data) do
        value.each do |key, security_ids|
          # Validate that the key is a valid exchange segment
          key.failure("#{key} is not a valid exchange segment.") unless EXCHANGE_SEGMENTS.include?(key)

          # Validate that the security IDs are an array of integers
          unless security_ids.is_a?(Array) && security_ids.all? { |id| id.is_a?(Integer) }
            key.failure("Security IDs for #{key} must be an array of integers.")
          end

          # Ensure there is at least one security ID
          key.failure("Security IDs for #{key} cannot be empty.") if security_ids.empty?
        end

        # Ensure at least one valid exchange segment is provided
        key.failure("At least one exchange segment must be provided with security IDs.") if value.empty?
      end
    end
  end
end
