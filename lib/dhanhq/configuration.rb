# frozen_string_literal: true

# lib/dhanhq/configuration.rb

module Dhanhq
  # Manages the configuration for the DhanHQ client gem.
  class Configuration
    # @return [String] The client ID used for authenticating API requests.
    attr_accessor :client_id

    # @return [String] The access token used for authenticating API requests.
    attr_accessor :access_token

    # @return [Boolean] Flag to enable or disable the Data API functionality.
    attr_accessor :enable_data_api

    # Initializes the configuration with default values.
    def initialize
      @client_id = ENV.fetch("DHAN_CLIENT_ID", nil)
      @access_token = ENV.fetch("DHAN_ACCESS_TOKEN", nil)
      @enable_data_api = false
    end

    # Validates the configuration, ensuring required attributes are present.
    #
    # @raise [ArgumentError] if client_id or access_token is not configured.
    def validate!
      raise ArgumentError, "Client ID is not configured" if @client_id.nil? || @client_id.empty?
      raise ArgumentError, "Access Token is not configured" if @access_token.nil? || @access_token.empty?
    end
  end

  class << self
    # @return [Dhanhq::Configuration] The current configuration instance.
    attr_accessor :configuration

    # Configures the DhanHQ client gem.
    #
    # Example:
    #   Dhanhq.configure do |config|
    #     config.client_id = "your_client_id"
    #     config.access_token = "your_access_token"
    #     config.enable_data_api = true
    #   end
    #
    # @yield [configuration] Provides the current configuration to the block.
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
      configuration.validate!
    end
  end
end
