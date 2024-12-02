# frozen_string_literal: true

# Callback to handle messages
on_message = proc do |data|
  puts "Market Feed Update: #{data}"
end

# Instruments to subscribe
instruments = [
  { exchange_segment: "NSE_EQ", security_id: "1333", subscription_type: "Ticker" },
  { exchange_segment: "NSE_EQ", security_id: "500180", subscription_type: "Full" }
]

# Initialize MarketFeed WebSocket
market_feed = Dhanhq::WebSockets::MarketFeed.new(
  instruments: instruments,
  on_message: on_message
)

# Connect and start receiving updates
market_feed.connect

# Example: Unsubscribe from an instrument
market_feed.unsubscribe([{ exchange_segment: "NSE_EQ", security_id: "1333", subscription_type: "Ticker" }])

# Disconnect when done
market_feed.disconnect
