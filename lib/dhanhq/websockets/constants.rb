# frozen_string_literal: true

module Dhanhq
  module Websockets
    # A module to hold constants for the Websockets DhanHQ API
    module Constants
      # WebSocket URL for DhanHQ Live Market Feed
      MARKET_FEED_WSS = "wss://api-feed.dhan.co"

      # Exchange Segment
      IDX = 0
      NSE = 1
      NSE_FNO = 2
      NSE_CURR = 3
      BSE = 4
      MCX = 5
      BSE_CURR = 7
      BSE_FNO = 8

      # Request Code
      TICKER = 15
      QUOTE = 17
      DEPTH = 19
      FULL = 21
    end
  end
end
