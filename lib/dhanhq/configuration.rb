# frozen_string_literal: true

module Dhanhq
  # Manages the configuration for the DhanHQ client gem.
  class Configuration
    attr_accessor :base_url, :client_id, :access_token, :enable_data_api

    # Initializes the configuration with default values.
    def initialize
      @base_url = Dhanhq::Constants::BASE_URL
      @client_id = nil
      @access_token = nil
      @enable_data_api = false
    end

    # Validates the configuration, ensuring required attributes are present.
    #
    # @raise [ArgumentError] if client_id or access_token is not configured.
    def validate!
      raise ArgumentError, "Client ID must be configured" if client_id.nil? || client_id.empty?
      raise ArgumentError, "Access Token must be configured" if access_token.nil? || access_token.empty?
    end
  end
end
