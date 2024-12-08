# frozen_string_literal: true

module Dhanhq
  module Errors
    # Base class for all API-related errors
    class ApiError < StandardError
      attr_reader :message, :status, :details

      def initialize(message = "An unknown error occurred", status = nil, details = {})
        @message = message
        @status = status
        @details = details
        super("#{self.class.name}: #{message}")
      end
    end
  end
end
