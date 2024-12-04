# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles endpoints related to Ledger and Trade History APIs
    class Ledger < BaseApi
      class << self
        # Retrieve Trading Account Ledger Report for a specific date range.
        #
        # @param from_date [String] Start date in 'YYYY-MM-DD' format
        # @param to_date [String] End date in 'YYYY-MM-DD' format
        # @return [Array<Hash>] The ledger report data
        #
        # @example Get ledger report:
        #   ledger.get_ledger_report('2023-01-01', '2023-01-31')
        def get_ledger_report(from_date, to_date)
          validate_params({ from_date:, to_date: }, Dhanhq::Validators::Ledger::LedgerReportSchema)
          endpoint = "/ledger?from_date=#{from_date}&to_date=#{to_date}"
          request(:get, endpoint)
        end

        # Retrieve Trade History for all orders in a specific date range and page.
        #
        # @param from_date [String] Start date in 'YYYY-MM-DD' format
        # @param to_date [String] End date in 'YYYY-MM-DD' format
        # @param page [Integer] Page number (default is 0)
        # @return [Array<Hash>] The trade history data
        #
        # @example Get trade history:
        #   ledger.get_trade_history('2023-01-01', '2023-01-31', 1)
        def get_trade_history(from_date, to_date, page)
          validate_params({ from_date:, to_date:, page: }, Dhanhq::Validators::Ledger::TradeHistorySchema)
          endpoint = "/trades/#{from_date}/#{to_date}/#{page}"
          request(:get, endpoint)
        end
      end
    end
  end
end
