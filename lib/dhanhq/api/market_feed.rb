# frozen_string_literal: true

require_relative "../contracts/market_quote_contract"
module Dhanhq
  module API
    # Provides methods to retrieve market feed data via Dhanhq's API.
    #
    # The `MarketFeed` class extends `Dhanhq::API::Base` and includes methods to:
    # - Fetch Last Traded Price (LTP).
    # - Fetch Open-High-Low-Close (OHLC) data.
    # - Fetch detailed market quotes.
    #
    # Example usage:
    #   # Fetch Last Traded Price
    #   ltp_data = MarketFeed.ltp({
    #     data: {
    #       "NSE_EQ" => [12345, 67890],
    #       "BSE_EQ" => [11223]
    #     }
    #   })
    #
    #   # Fetch OHLC data
    #   ohlc_data = MarketFeed.ohlc({
    #     data: {
    #       "NSE_EQ" => [12345],
    #       "MCX_COMM" => [67890]
    #     }
    #   })
    #
    #   # Fetch market quotes
    #   quote_data = MarketFeed.quote({
    #     data: {
    #       "NSE_EQ" => [12345]
    #     }
    #   })
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see Dhanhq::Contracts::MarketQuoteContract For validation rules.
    # @see https://dhanhq.co/docs/v2/market-quote/ Dhanhq API Documentation
    class MarketFeed < Base
      class << self
        # Fetches the Last Traded Price (LTP) for the given securities.
        #
        # @param instruments [Hash] The request parameters for fetching LTP.
        #   Example:
        #     {
        #       "NSE_EQ" => [11536],
        #       "NSE_FNO" => [49081, 49082]
        #     }
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        def ltp(instruments)
          # Validate the instruments using the MarketQuoteContract
          # validated_params = validate_with(Dhanhq::Contracts::MarketQuoteContract, { data: instruments })

          # Send the API request
          # post("/v2/marketfeed/ltp", validated_params[:data])
          post("/v2/marketfeed/ltp", instruments)
        end

        # Fetches the Open-High-Low-Close (OHLC) data for the given securities.
        #
        # @param securities [Hash] The request parameters for fetching OHLC data.
        #   Required keys:
        #   - `data` [Hash{String => Array<Integer>}] A hash where keys are exchange segments
        #      (e.g., "NSE_EQ", "MCX_COMM") and values are arrays of security IDs.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Fetch OHLC data:
        #   ohlc_data = MarketFeed.ohlc({
        #     data: {
        #       "NSE_EQ" => [12345],
        #       "MCX_COMM" => [67890]
        #     }
        #   })
        def ohlc(securities)
          validated_params = validate_with(Dhanhq::Contracts::MarketQuoteContract, { data: securities })
          post("/v2/marketfeed/ohlc", validated_params[:data])
        end

        # Fetches detailed market quotes for the given securities.
        #
        # @param securities [Hash] The request parameters for fetching market quotes.
        #   Required keys:
        #   - `data` [Hash{String => Array<Integer>}] A hash where keys are exchange segments
        #      (e.g., "NSE_EQ") and values are arrays of security IDs.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Fetch market quotes:
        #   quote_data = MarketFeed.quote({
        #     data: {
        #       "NSE_EQ" => [12345]
        #     }
        #   })
        def quote(securities)
          validated_params = validate_with(Dhanhq::Contracts::MarketQuoteContract, { data: securities })
          post("/v2/marketfeed/quote", validated_params[:data])
        end
      end
    end
  end
end
