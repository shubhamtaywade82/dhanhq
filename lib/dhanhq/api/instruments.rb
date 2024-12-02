# frozen_string_literal: true

module Dhanhq
  module Api
    class Instruments < BaseApi
      def self.fetch_instruments
        request(:get, Constants::COMPACT_CSV_URL)
      end
    end
  end
end
