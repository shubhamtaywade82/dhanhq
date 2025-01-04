# frozen_string_literal: true

module Dhanhq
  module Contracts
    # Validation contract for fetching Intraday OHLC data via Dhanhq's API.
    #
    # This contract ensures the correctness of parameters for intraday OHLC requests.
    # It validates the instrument type, time interval, date range, and other required fields.
    #
    # Example usage:
    #   contract = Dhanhq::Contracts::IntradayOHLCContract.new
    #   result = contract.call(
    #     securityId: "1001",
    #     exchangeSegment: "NSE_EQ",
    #     instrument: "EQUITY",
    #     interval: "15",
    #     fromDate: "2024-01-01",
    #     toDate: "2024-01-31"
    #   )
    #   result.success? # => true or false
    #
    # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
    class IntradayOHLCContract < BaseContract
      # Parameters and validation rules for the Intraday OHLC request.
      #
      # @!attribute [r] securityId
      #   @return [String] Required. Unique identifier for the security.
      # @!attribute [r] exchangeSegment
      #   @return [String] Required. The segment of the exchange.
      #     Must be one of: `EXCHANGE_SEGMENTS`.
      # @!attribute [r] instrument
      #   @return [String] Required. The type of instrument for OHLC data.
      #     Must be one of: INDEX, FUTIDX, OPTIDX, EQUITY, FUTSTK, OPTSTK, FUTCOM, OPTFUT, FUTCUR, OPTCUR.
      # @!attribute [r] interval
      #   @return [String] Required. The time interval for OHLC data in minutes.
      #     Must be one of: 1, 5, 15, 25, 60.
      # @!attribute [r] fromDate
      #   @return [String] Required. The start date for the OHLC data in `YYYY-MM-DD` format.
      # @!attribute [r] toDate
      #   @return [String] Required. The end date for the OHLC data in `YYYY-MM-DD` format.
      #
      #   @example Valid input:
      #     {
      #       securityId: "1001",
      #       exchangeSegment: "NSE_EQ",
      #       instrument: "EQUITY",
      #       interval: "15",
      #       fromDate: "2024-01-01",
      #       toDate: "2024-01-31"
      #     }
      #   @example Invalid date range:
      #     {
      #       fromDate: "2024-01-31",
      #       toDate: "2024-01-01"
      #     }
      #     => Adds failure message "fromDate must be earlier than or equal to toDate".
      params do
        required(:securityId).filled(:string)
        required(:exchangeSegment).filled(:string, included_in?: EXCHANGE_SEGMENTS)
        required(:instrument).filled(:string,
                                     included_in?: %w[INDEX FUTIDX OPTIDX EQUITY FUTSTK OPTSTK FUTCOM OPTFUT FUTCUR
                                                      OPTCUR])
        required(:interval).filled(:string, included_in?: %w[1 5 15 25 60])
        required(:fromDate).filled(:string, format?: /\A\d{4}-\d{2}-\d{2}\z/) # YYYY-MM-DD
        required(:toDate).filled(:string, format?: /\A\d{4}-\d{2}-\d{2}\z/) # YYYY-MM-DD
      end

      # Custom validation to ensure that `fromDate` is earlier than or equal to `toDate`.
      #
      # @example Invalid date range:
      #   fromDate: "2024-01-31", toDate: "2024-01-01"
      #   => Adds failure message "must be earlier than or equal to toDate".
      #
      # @param fromDate [String] The start date for the OHLC data.
      # @param toDate [String] The end date for the OHLC data.
      rule(:fromDate, :toDate) do
        if Date.parse(values[:fromDate]) > Date.parse(values[:toDate])
          key(:fromDate).failure("must be earlier than or equal to toDate")
        end
      end
    end
  end
end
