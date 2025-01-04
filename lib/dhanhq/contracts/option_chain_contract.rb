# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for fetching Option Chain data via Dhanhq's API.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::OptionChainContract.new
    #   result = contract.call(
    #     UnderlyingScrip: 13,
    #     UnderlyingSeg: "IDX_I",
    #     Expiry: "2024-10-31"
    #   )
    #   result.success? # => true or false
    #
    class OptionChainContract < BaseContract
      SEGMENTS = %w[IDX_I NSE_EQ NSE_FNO BSE_EQ BSE_FNO MCX_COMM].freeze

      # Validation rules for Option Chain API parameters.
      params do
        required(:UnderlyingScrip).value(:integer)
        required(:UnderlyingSeg).value(included_in?: SEGMENTS)
        required(:Expiry).value(:string, format?: /^\d{4}-\d{2}-\d{2}$/)
      end
    end
  end
end
