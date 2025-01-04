# frozen_string_literal: true

require "dry-validation"
require_relative "../constants"

module Dhanhq
  module Contracts
    # Base contract that includes shared logic and constants.
    class BaseContract < Dry::Validation::Contract
      # Include constants to make them accessible in all derived contracts
      include Dhanhq::Constants
    end
  end
end
