# frozen_string_literal: true

module Dhanhq
  # A helper module to map numeric exchange codes to string representations
  module ExchangeHelper
    EXCHANGE_MAP = {
      0 => "IDX_I",
      1 => "NSE_EQ",
      2 => "NSE_FNO",
      3 => "NSE_CURRENCY",
      4 => "BSE_EQ",
      5 => "MCX_COMM",
      7 => "BSE_CURRENCY",
      8 => "BSE_FNO"
    }.freeze

    # Convert numeric exchange code to string representation
    #
    # @param code [Integer] The numeric exchange code
    # @return [String, nil] The corresponding string representation or nil if not found
    def self.exchange_code_to_string(code)
      EXCHANGE_MAP[code]
    end
  end
end
