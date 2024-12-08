# frozen_string_literal: true

module Dhanhq
  module Errors
    # Raised for client-side errors (4xx)
    class ClientError < ApiError
      def initialize(message = "Client error", status = 400, details = {})
        super(message, status, details) # rubocop:disable Style/SuperArguments
      end
    end
  end
end
