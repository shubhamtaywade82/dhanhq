# frozen_string_literal: true

module Dhanhq
  # Custom error class for handling DhanHQ gem errors.
  class Error < StandardError; end
  class ApiError < Error; end
end
