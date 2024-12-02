# frozen_string_literal: true

module Dhanhq
  module WebSockets
    # Handles Order Update WebSocket for real-time order updates
    class OrderUpdate < BaseWebSocket
      ORDER_UPDATE_URL = "wss://api-order-update.dhan.co"

      def websocket_url
        ORDER_UPDATE_URL
      end

      def on_open
        authenticate
      end

      private

      def authenticate
        payload = {
          LoginReq: {
            MsgCode: 42,
            ClientId: @client_id,
            Token: @access_token
          },
          UserType: "SELF"
        }
        send_message(payload)
      end
    end
  end
end
