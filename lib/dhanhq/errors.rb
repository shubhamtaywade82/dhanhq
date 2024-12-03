# frozen_string_literal: true

module Dhanhq
  module Errors
    # Base class for all API errors
    class ApiError < StandardError; end

    # Raised for client-side errors (400-499)
    class ClientError < ApiError; end

    # Raised for server-side errors (500-599)
    class ServerError < ApiError; end
  end
end
