# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for fetching Expiry List data via Dhanhq's API.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::ExpiryListContract.new
    #   result = contract.call(
    #     UnderlyingScrip: 13,
    #     UnderlyingSeg: "IDX_I"
    #   )
    #   result.success? # => true or false
    #
    class ExpiryListContract < BaseContract
      SEGMENTS = %w[IDX_I NSE_EQ NSE_FNO BSE_EQ BSE_FNO MCX_COMM].freeze

      # Validation rules for Expiry List API parameters.
      params do
        required(:UnderlyingScrip).value(:integer)
        required(:UnderlyingSeg).value(included_in?: SEGMENTS)
      end
    end
  end
end
