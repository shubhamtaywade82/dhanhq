# frozen_string_literal: true

module Dhanhq
  module Errors
    # Raised for server-side errors (5xx)
    class ServerError < ApiError
      attr_reader :status, :details

      def initialize(message = "Unknown server error", status = 500, details = {})
        @status = status
        @details = details
        super("Server Error: #{status} - #{details["error"] || "Unknown error"}: #{message}")
      end
    end
  end
end
