# frozen_string_literal: true

require "dry/validation"

module Dhanhq
  module Validators
    module DataApis
      class MarketfeedLtpValidator < Dry::Validation::Contract
        params do
          required(:symbols).filled(:array).each(:string)
        end
      end
    end
  end
end
