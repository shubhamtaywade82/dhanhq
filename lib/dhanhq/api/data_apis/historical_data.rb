# frozen_string_literal: true

module Dhanhq
  module Api
    class HistoricalData < BaseApi
      class << self
        def fetch(params)
          validate_params!(params, Dhanhq::Validators::DataApis::HistoricalDataValidator)
          request(:post, "/charts/historical", params)
        end
      end
    end
  end
end
