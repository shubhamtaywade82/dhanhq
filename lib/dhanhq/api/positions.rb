# frozen_string_literal: true

module Dhanhq
  module Api
    class Positions < BaseApi
      def self.fetch_positions
        request(:get, "/positions")
      end

      def self.close_position(security_id:, exchange_segment:, quantity:, transaction_type:)
        payload = {
          securityId: security_id,
          exchangeSegment: Constants::EXCHANGE_MAP[exchange_segment] || exchange_segment,
          quantity: quantity,
          transactionType: transaction_type
        }
        request(:post, "/positions/convert", payload)
      end
    end
  end
end
