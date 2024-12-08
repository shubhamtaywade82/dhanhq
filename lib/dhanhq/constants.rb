# frozen_string_literal: true

module Dhanhq
  # A module to hold all constants for the DhanHQ API
  module Constants
    # API Base URL
    BASE_URL = "https://api.dhan.co/v2"

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

    ENDPOINTS = {
      orders: "/orders",
      modify_order: "/orders/modify",
      cancel_order: "/orders/cancel",
      positions: "/portfolio/positions",
      holdings: "/portfolio/holdings",
      market_data: "/market-data",
      funds: "/funds"
      # Add more as per the Dhanhq v2 API documentation
    }.freeze

    # Transaction Types
    TRANSACTION_TYPES = %w[BUY SELL].freeze

    # Exchange Segments
    EXCHANGE_SEGMENTS = {
      "IDX_I" => "Index",
      "NSE_EQ" => "NSE Equity Cash",
      "NSE_FNO" => "NSE Futures & Options",
      "NSE_CURRENCY" => "NSE Currency",
      "BSE_EQ" => "BSE Equity Cash",
      "MCX_COMM" => "MCX Commodity",
      "BSE_CURRENCY" => "BSE Currency",
      "BSE_FNO" => "BSE Futures & Options"
    }.freeze

    # Product Types
    PRODUCT_TYPES = %w[CNC INTRADAY MARGIN CO BO MTF].freeze

    # Order Types
    ORDER_TYPES = %w[LIMIT MARKET STOP_LOSS STOP_LOSS_MARKET].freeze

    # Validity Types
    VALIDITY_TYPES = %w[DAY IOC].freeze

    # Order Statuses
    ORDER_STATUSES = {
      "TRANSIT" => "Did not reach the exchange server",
      "PENDING" => "Awaiting execution",
      "REJECTED" => "Rejected by broker/exchange",
      "CANCELLED" => "Cancelled by user",
      "TRADED" => "Executed successfully",
      "EXPIRED" => "Validity of order expired"
    }.freeze

    # After Market Order Timings
    AMO_TIMINGS = %w[PRE_OPEN OPEN OPEN_30 OPEN_60].freeze

    # Expiry Codes
    EXPIRY_CODES = {
      0 => "Current Expiry/Near Expiry",
      1 => "Next Expiry",
      2 => "Far Expiry"
    }.freeze

    # Instrument Types
    INSTRUMENT_TYPES = {
      "INDEX" => "Index",
      "FUTIDX" => "Futures of Index",
      "OPTIDX" => "Options of Index",
      "EQUITY" => "Equity",
      "FUTSTK" => "Futures of Stock",
      "OPTSTK" => "Options of Stock",
      "FUTCOM" => "Futures of Commodity",
      "OPTFUT" => "Options of Commodity Futures",
      "FUTCUR" => "Futures of Currency",
      "OPTCUR" => "Options of Currency"
    }.freeze

    # Feed Request Codes
    FEED_REQUEST_CODES = {
      11 => "Connect Feed",
      12 => "Disconnect Feed",
      15 => "Subscribe - Ticker Packet",
      16 => "Unsubscribe - Ticker Packet",
      17 => "Subscribe - Quote Packet",
      18 => "Unsubscribe - Quote Packet",
      21 => "Subscribe - Full Packet",
      22 => "Unsubscribe - Full Packet"
    }.freeze

    # Feed Response Codes
    FEED_RESPONSE_CODES = {
      1 => "Index Packet",
      2 => "Ticker Packet",
      4 => "Quote Packet",
      5 => "OI Packet",
      6 => "Prev Close Packet",
      7 => "Market Status Packet",
      8 => "Full Packet",
      50 => "Feed Disconnect"
    }.freeze

    # Trading API Error Codes
    TRADING_API_ERRORS = {
      "DH-901" => "Client ID or user-generated access token is invalid or expired.",
      "DH-902" => "User has not subscribed to Data APIs or does not have access to Trading APIs.",
      "DH-903" => "Errors related to User's Account.",
      "DH-904" => "Too many requests breaching rate limits.",
      "DH-905" => "Missing required fields or bad values for parameters.",
      "DH-906" => "Incorrect request for order; cannot be processed.",
      "DH-907" => "System is unable to fetch data.",
      "DH-908" => "Internal server error.",
      "DH-909" => "Network error.",
      "DH-910" => "Error originating from other reasons."
    }.freeze

    # Data API Error Codes
    DATA_API_ERRORS = {
      800 => "Internal Server Error",
      804 => "Requested number of instruments exceeds limit",
      805 => "Too many requests or connections",
      806 => "Data APIs not subscribed",
      807 => "Access token is expired",
      808 => "Authentication Failed - Client ID or Access Token invalid",
      809 => "Access token is invalid",
      810 => "Client ID is invalid"
    }.freeze

    # Helper Methods

    # Convert numeric exchange code to string representation
    #
    # @param code [Integer] The numeric exchange code
    # @return [String, nil] The corresponding string representation or nil if not found
    def self.exchange_segment_to_string(code)
      EXCHANGE_SEGMENTS.key(code)
    end
  end
end
