# frozen_string_literal: true

module Dhanhq
  module Api
    class Marketfeed < BaseApi
      class << self
        def ltp(params)
          validate_params!(params, Dhanhq::Validators::DataApis::MarketfeedLtpValidator)
          request(:post, "/marketfeed/ltp", params)
        end

        def ohlc(params)
          validate_params!(params, Dhanhq::Validators::DataApis::MarketfeedOhlcValidator)
          request(:post, "/marketfeed/ohlc", params)
        end
      end
    end
  end
end
