# frozen_string_literal: true

module Dhanhq
  # Handles configuration settings for the DhanHQ gem.
  class Configuration
    # @return [String] The base URL for the API.
    attr_accessor :base_url

    # @return [String, nil] The client ID for authentication.
    attr_accessor :client_id

    # @return [String, nil] The access token for authentication.
    attr_accessor :access_token

    # Initializes the configuration with default values.
    def initialize
      @base_url = nil
      @client_id = nil
      @access_token = nil
    end

    # Validates the configuration settings.
    #
    # @raise [ArgumentError] If any configuration value is missing.
    def validate!
      raise ArgumentError, "BaseApi URL is missing" if @base_url.nil? || @base_url.empty?
      raise ArgumentError, "Client ID is missing" if @client_id.nil? || @client_id.empty?
      raise ArgumentError, "Access Token is missing" if @access_token.nil? || @access_token.empty?
    end
  end
end
