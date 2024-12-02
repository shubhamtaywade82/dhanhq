# frozen_string_literal: true

require "dhanhq"

# Initialize the DhanHQ client
Dhanhq.configure do |config|
  config.base_url = "https://api.dhan.co"
  config.client_id = "your_client_id" # Replace with your Dhan Client ID
  config.access_token = "your_access_token" # Replace with your access token
end

# Example usage of DhanHQ gem
begin
  # Place an order for Equity Cash
  response = Dhanhq::Api::Orders.place_order(
    security_id: "1333", # HDFC Bank
    exchange_segment: Dhanhq::Constants::NSE,
    transaction_type: Dhanhq::Constants::BUY,
    quantity: 10,
    order_type: Dhanhq::Constants::MARKET,
    product_type: Dhanhq::Constants::INTRA,
    price: 0
  )
  puts "Equity Cash Order Response: #{response}"

  # Place an order for NSE Futures & Options
  response = Dhanhq::Api::Orders.place_order(
    security_id: "52175", # Nifty PE
    exchange_segment: Dhanhq::Constants::NSE_FNO,
    transaction_type: Dhanhq::Constants::BUY,
    quantity: 550,
    order_type: Dhanhq::Constants::MARKET,
    product_type: Dhanhq::Constants::INTRA,
    price: 0
  )
  puts "F&O Order Response: #{response}"

  # Place an order for Currency
  response = Dhanhq::Api::Orders.place_order(
    security_id: "10093", # USDINR
    exchange_segment: Dhanhq::Constants::CUR,
    transaction_type: Dhanhq::Constants::BUY,
    quantity: 1,
    order_type: Dhanhq::Constants::MARKET,
    validity: Dhanhq::Constants::DAY,
    product_type: Dhanhq::Constants::INTRA,
    price: 0
  )
  puts "Currency Order Response: #{response}"

  # Fetch all orders
  orders = Dhanhq::Api::Orders.orders_list
  puts "All Orders: #{orders}"

  # Get order by ID
  order_id = "1234567890" # Replace with a valid order ID
  order_details = Dhanhq::Api::Orders.get_order_by_id(order_id)
  puts "Order Details: #{order_details}"

  # Modify an existing order
  modify_response = Dhanhq::Api::Orders.modify_order(
    order_id: "13200000321", # Replace with valid order ID
    order_type: Dhanhq::Constants::LIMIT,
    leg_name: "ENTRY_LEG",
    quantity: 10,
    price: 200,
    trigger_price: 0,
    disclosed_quantity: 0,
    validity: Dhanhq::Constants::DAY
  )
  puts "Modify Order Response: #{modify_response}"

  # Cancel an order
  cancel_response = Dhanhq::Api::Orders.cancel_order("1234567890") # Replace with valid order ID
  puts "Cancel Order Response: #{cancel_response}"

  # Fetch trade history
  trade_history = Dhanhq::Api::Orders.get_trade_history(
    from_date: "2024-12-01",
    to_date: "2024-12-02",
    page_number: 0
  )
  puts "Trade History: #{trade_history}"
rescue StandardError => e
  puts "Error occurred: #{e.message}"
end
