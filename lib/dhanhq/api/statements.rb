# frozen_string_literal: true

module Dhanhq
  module API
    # Provides methods to retrieve account statements and trade history via Dhanhq's API.
    #
    # The `Statements` class extends `Dhanhq::API::Base` and includes methods to:
    # - Retrieve the trading account ledger for a specified date range.
    # - Retrieve historical trade data with pagination support.
    #
    # Example usage:
    #   # Fetch account ledger
    #   ledger = Statements.ledger(from_date: "2023-01-01", to_date: "2023-12-31")
    #
    #   # Fetch trade history
    #   trade_history = Statements.trade_history(from_date: "2023-01-01", to_date: "2023-12-31", page: 1)
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see https://dhanhq.co/docs/v2/statements/ Dhanhq API Documentation
    class Statements < Base
      class << self
        # Retrieves the trading account ledger for a specified date range.
        #
        # @param from_date [String] The start date for the ledger in `YYYY-MM-DD` format.
        # @param to_date [String] The end date for the ledger in `YYYY-MM-DD` format.
        # @return [Array<Hash>] The ledger entries as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Fetch account ledger:
        #   ledger = Statements.ledger(from_date: "2023-01-01", to_date: "2023-12-31")
        def ledger(from_date:, to_date:)
          get("/ledger", { from_date: from_date, to_date: to_date })
        end

        # Retrieves historical trade data for a specified date range, with optional pagination.
        #
        # @param from_date [String] The start date for the trade history in `YYYY-MM-DD` format.
        # @param to_date [String] The end date for the trade history in `YYYY-MM-DD` format.
        # @param page [Integer] (Optional) The page number for pagination. Default is `0`.
        # @return [Array<Hash>] The trade history as parsed JSON objects.
        # @raise [Dhanhq::Error] If the API returns an error.
        #
        # @example Fetch trade history:
        #   trade_history = Statements.trade_history(from_date: "2023-01-01", to_date: "2023-12-31", page: 1)
        def trade_history(from_date:, to_date:, page: 0)
          get("/trades", { from_date: from_date, to_date: to_date, page: page })
        end
      end
    end
  end
end
