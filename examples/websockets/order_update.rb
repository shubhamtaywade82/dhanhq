# frozen_string_literal: true

# Callback to handle order updates
on_message = proc do |data|
  puts "Order Update Received: #{data}"
end

# Initialize OrderUpdate WebSocket
order_update = Dhanhq::WebSockets::OrderUpdate.new(on_message: on_message)

order_update.connect
order_update.disconnect
