# frozen_string_literal: true

module Dhanhq
  # A module to hold all constants for the DhanHQ API
  module Constants
    # CSV URLs for Security ID List
    COMPACT_CSV_URL = "https://images.dhan.co/api-data/api-scrip-master.csv"
    DETAILED_CSV_URL = "https://images.dhan.co/api-data/api-scrip-master-detailed.csv"

    # Exchange Segments
    NSE = "NSE_EQ"
    BSE = "BSE_EQ"
    CUR = "NSE_CURRENCY"
    MCX = "MCX_COMM"
    FNO = "NSE_FNO"
    NSE_FNO = "NSE_FNO"
    BSE_FNO = "BSE_FNO"
    INDEX = "IDX_I"

    # Transaction Types
    BUY = "BUY"
    SELL = "SELL"

    # Product Types
    CNC = "CNC"
    INTRA = "INTRADAY"
    MARGIN = "MARGIN"
    CO = "CO"
    BO = "BO"
    MTF = "MTF"

    # Order Types
    LIMIT = "LIMIT"
    MARKET = "MARKET"
    SL = "STOP_LOSS"
    SLM = "STOP_LOSS_MARKET"

    # Validity Types
    DAY = "DAY"
    IOC = "IOC"

    EXCHANGE_MAP = {
      0 => INDEX,
      1 => NSE,
      2 => NSE_FNO,
      3 => CUR,
      4 => BSE,
      5 => MCX,
      7 => "BSE_CURRENCY",
      8 => BSE_FNO
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
