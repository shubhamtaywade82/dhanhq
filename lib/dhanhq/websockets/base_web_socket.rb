# frozen_string_literal: true

require "websocket-client-simple"
require "json"

module Dhanhq
  module WebSockets
    # Base class to handle common WebSocket functionalities
    class BaseWebSocket
      attr_reader :on_message_callback

      def initialize(on_message: nil)
        @client_id = Dhanhq.configuration.client_id
        @access_token = Dhanhq.configuration.access_token
        @on_message_callback = on_message
      end

      def connect
        @ws = WebSocket::Client::Simple.connect(websocket_url)
        setup_event_listeners
      end

      def disconnect
        @ws&.close
      end

      private

      def setup_event_listeners
        @ws.on :open do
          puts "WebSocket connection established: #{self.class.name}."
          on_open if respond_to?(:on_open)
        end

        @ws.on :message do |msg|
          handle_message(msg.data)
        end

        @ws.on :close do |e|
          puts "WebSocket connection closed: #{e}"
        end

        @ws.on :error do |e|
          puts "WebSocket error: #{e}"
        end
      end

      def handle_message(data)
        parsed_data = JSON.parse(data)
        if on_message_callback
          on_message_callback.call(parsed_data)
        else
          puts "Received message: #{parsed_data}"
        end
      end

      def send_message(payload)
        return unless @ws&.open?

        @ws.send(payload.to_json)
      end

      # Methods to be implemented by subclasses
      def websocket_url
        raise NotImplementedError, "Subclasses must define `websocket_url`."
      end

      def on_open
        raise NotImplementedError, "Subclasses must define `on_open`."
      end
    end
  end
end
