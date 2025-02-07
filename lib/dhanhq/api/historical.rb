# frozen_string_literal: true

require_relative "../contracts/historical_ohlc_contract"
require_relative "../contracts/intraday_ohlc_contract"

module Dhanhq
  module API
    # Provides methods to retrieve historical data via Dhanhq's API.
    #
    # The `Historical` class extends `Dhanhq::API::Base` and includes methods to:
    # - Retrieve daily historical data.
    # - Retrieve intraday historical data.
    #
    # Example usage:
    #   # Retrieve daily historical data
    #   historical_data = Historical.daily({
    #     securityId: "1001",
    #     exchangeSegment: "NSE_EQ",
    #     fromDate: "2023-01-01",
    #     toDate: "2023-12-31"
    #   })
    #
    #   # Retrieve intraday historical data
    #   intraday_data = Historical.intraday({
    #     securityId: "1001",
    #     exchangeSegment: "NSE_EQ",
    #     interval: "15",
    #     fromDate: "2023-01-01",
    #     toDate: "2023-01-01"
    #   })
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see https://dhanhq.co/docs/v2/historical-data/ Dhanhq API Documentation
    class Historical < Base
      class << self
        # Retrieves daily historical data.
        #
        # @param params [Hash] The request parameters for retrieving daily historical data.
        #   Required keys:
        #   - `securityId` [String] Unique identifier for the security.
        #   - `exchangeSegment` [String] Segment of the exchange.
        #   - `fromDate` [String] Start date in `YYYY-MM-DD` format.
        #   - `toDate` [String] End date in `YYYY-MM-DD` format.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve daily historical data:
        #   historical_data = Historical.daily({
        #     securityId: "1001",
        #     exchangeSegment: "NSE_EQ",
        #     fromDate: "2023-01-01",
        #     toDate: "2023-12-31"
        #   })
        def daily(params)
          validated_params = validate_with(Dhanhq::Contracts::HistoricalOHLCContract, params)
          post("/v2/charts/historical", validated_params)
        end

        # Retrieves intraday historical data.
        #
        # @param params [Hash] The request parameters for retrieving intraday historical data.
        #   Required keys:
        #   - `securityId` [String] Unique identifier for the security.
        #   - `exchangeSegment` [String] Segment of the exchange.
        #   - `interval` [String] Interval for the data in minutes (e.g., "1", "5", "15").
        #   - `fromDate` [String] Start date in `YYYY-MM-DD` format.
        #   - `toDate` [String] End date in `YYYY-MM-DD` format.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Retrieve intraday historical data:
        #   intraday_data = Historical.intraday({
        #     securityId: "1001",
        #     exchangeSegment: "NSE_EQ",
        #     interval: "15",
        #     fromDate: "2023-01-01",
        #     toDate: "2023-01-01"
        #   })
        def intraday(params)
          validated_params = validate_with(Dhanhq::Contracts::IntradayOHLCContract, params)
          post("/v2/charts/intraday", validated_params)
        end
      end
    end
  end
end
