# frozen_string_literal: true

module Dhanhq
  module WebSockets
    # Handles Market Feed WebSocket for real-time market data
    class MarketFeed < BaseWebSocket
      attr_reader :instruments

      MARKET_FEED_URL = "wss://api-feed.dhan.co"

      def initialize(instruments:, on_message: nil)
        super(on_message: on_message)
        @instruments = instruments
      end

      def websocket_url
        MARKET_FEED_URL
      end

      def on_open
        subscribe
      end

      def subscribe
        payload = {
          "client_id" => @client_id,
          "access_token" => @access_token,
          "instruments" => format_instruments(instruments),
          "action" => "subscribe"
        }
        send_message(payload)
      end

      def unsubscribe(unsub_instruments)
        payload = {
          "client_id" => @client_id,
          "access_token" => @access_token,
          "instruments" => format_instruments(unsub_instruments),
          "action" => "unsubscribe"
        }
        send_message(payload)
      end

      private

      def format_instruments(instruments)
        instruments.map do |instrument|
          {
            "exchange_segment" => instrument[:exchange_segment],
            "security_id" => instrument[:security_id],
            "subscription_type" => instrument[:subscription_type]
          }
        end
      end
    end
  end
end
