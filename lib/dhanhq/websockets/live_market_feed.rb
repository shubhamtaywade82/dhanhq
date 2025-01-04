# frozen_string_literal: true

# lib/dhanhq/websockets/live_market_feed.rb

require "websocket/driver"
require "socket"
require "json"
require "bindata"

module Dhanhq
  module Websockets
    class LiveMarketFeed
      MARKET_FEED_URL = "wss://api-feed.dhan.co"

      attr_reader :client_id, :access_token, :subscribed_instruments, :url

      def initialize
        @client_id = Dhanhq.configuration.client_id
        @access_token = Dhanhq.configuration.access_token
        @subscribed_instruments = []
        @socket = nil
        @driver = nil
        @url = market_feed_url
      end

      def connect
        uri = URI.parse(url)
        @socket = TCPSocket.new(uri.host, uri.port)
        @driver = WebSocket::Driver.client(self)

        setup_callbacks
        @driver.start

        Thread.new { listen_socket }
        start_ping_pong

        puts "Market feed connection established."
      end

      def subscribe(instruments)
        instruments.each_slice(100) do |batch|
          send_message(
            RequestCode: 15,
            InstrumentCount: batch.size,
            InstrumentList: batch.map do |inst|
              { ExchangeSegment: inst[:exchange_segment], SecurityId: inst[:security_id] }
            end
          )
        end
        @subscribed_instruments.concat(instruments)
      end

      def unsubscribe(instruments)
        instruments.each_slice(100) do |batch|
          send_message(
            RequestCode: 16,
            InstrumentCount: batch.size,
            InstrumentList: batch.map do |inst|
              { ExchangeSegment: inst[:exchange_segment], SecurityId: inst[:security_id] }
            end
          )
        end
        @subscribed_instruments -= instruments
      end

      def disconnect
        send_message(RequestCode: 16) # Unsubscribe all
        @socket.close
        puts "Connection closed!"
      end

      # Required by WebSocket::Driver
      def write(data)
        @socket.write(data)
      end

      private

      def market_feed_url
        "#{MARKET_FEED_URL}?version=2&token=#{@access_token}&clientId=#{@client_id}&authType=2"
      end

      def setup_callbacks
        @driver.on(:message) { |msg| handle_message(msg.data) }
        @driver.on(:ping) { @driver.pong }
        @driver.on(:close) { puts "Connection closed by server." }
        @driver.on(:error) { |e| puts "Error: #{e.message}" }
      end

      def listen_socket
        while (data = @socket.readpartial(1024))
          @driver.parse(data)
        end
      rescue EOFError
        puts "Socket closed by server."
      end

      def send_message(message)
        pp message.to_json
        @driver.text(message.to_json)
      end

      def handle_message(data)
        parsed_data = BinaryParser.new(data).parse
        puts "Parsed Data: #{parsed_data.inspect}"
      end

      def start_ping_pong
        Thread.new do
          loop do
            sleep 10
            @driver.ping("Ping")
          end
        end
      end
    end
  end
end
