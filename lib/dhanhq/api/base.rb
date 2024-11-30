# frozen_string_literal: true

module Dhanhq
  module Api
    # Base class for all API modules
    class Base
      class << self
        # Provides a shared client instance
        #
        # @return [Dhanhq::Client] The initialized client
        def client
          @client ||= Dhanhq::Client.new
        end

        # Helper method for making requests
        #
        # @param method [Symbol] HTTP method (:get, :post, etc.)
        # @param endpoint [String] API endpoint (relative to base_url)
        # @param params [Hash] Request parameters
        # @return [Hash] Parsed response
        def request(method, endpoint, params = {})
          client.request(method, endpoint, params)
        end
      end
    end
  end
end
