# frozen_string_literal: true

# lib/dhanhq/parsers/binary_parser.rb

require "bindata"

module Dhanhq
  module Parsers
    class BinaryParser
      HEADER_SIZE = 8

      def initialize(data)
        @data = data
      end

      def parse
        header = parse_header
        case header[:feed_response_code]
        when 2 then parse_ticker(header)
        when 4 then parse_quote(header)
        when 8 then parse_full_packet(header)
        else
          { error: "Unknown feed response code: #{header[:feed_response_code]}" }
        end
      end

      private

      def parse_header
        BinData::Struct.new(
          feed_response_code: :uint8,
          message_length: :uint16,
          exchange_segment: :uint8,
          security_id: :uint32
        ).read(@data[0...HEADER_SIZE])
      end

      def parse_ticker(header)
        BinData::Struct.new(
          last_traded_price: :float,
          last_trade_time: :uint32
        ).read(@data[HEADER_SIZE..])
                       .merge(header)
      end

      def parse_quote(header)
        BinData::Struct.new(
          last_traded_price: :float,
          last_traded_quantity: :uint16,
          last_trade_time: :uint32,
          average_trade_price: :float,
          volume: :uint32,
          total_sell_quantity: :uint32,
          total_buy_quantity: :uint32,
          day_open_value: :float,
          day_close_value: :float,
          day_high_value: :float,
          day_low_value: :float
        ).read(@data[HEADER_SIZE..])
                       .merge(header)
      end

      def parse_full_packet(header)
        BinData::Struct.new(
          last_traded_price: :float,
          last_traded_quantity: :uint16,
          last_trade_time: :uint32,
          average_trade_price: :float,
          volume: :uint32,
          total_sell_quantity: :uint32,
          total_buy_quantity: :uint32,
          open_interest: :uint32,
          highest_open_interest: :uint32,
          lowest_open_interest: :uint32,
          day_open_value: :float,
          day_close_value: :float,
          day_high_value: :float,
          day_low_value: :float
        ).read(@data[HEADER_SIZE..])
                       .merge(header)
      end
    end
  end
end
