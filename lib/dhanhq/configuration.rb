# frozen_string_literal: true

module Dhanhq
  # Manages the configuration for the Dhanhq API client.
  #
  # The `Configuration` class allows developers to set and manage credentials required to interact
  # with the Dhanhq API. It includes the `client_id` and `access_token` attributes, which are
  # necessary for authenticating API requests.
  #
  # Example usage:
  #   config = Dhanhq::Configuration.new
  #   config.client_id = "your_client_id"
  #   config.access_token = "your_access_token"
  #
  # @see https://dhanhq.co/docs/v2/ Dhanhq API Documentation
  class Configuration
    include Dhanhq::Constants
    # The client ID for the Dhanhq API.
    #
    # @return [String, nil] The client ID or `nil` if not set.
    attr_accessor :client_id

    # The access token for the Dhanhq API.
    #
    # @return [String, nil] The access token or `nil` if not set.
    attr_accessor :access_token

    attr_accessor :compact_csv_url, :detailed_csv_url

    # Optional: explicit base URL override
    attr_writer :base_url

    # Initializes a new configuration instance with `nil` values for `client_id` and `access_token`.
    #
    # @example Initialize configuration:
    #   config = Dhanhq::Configuration.new
    #   config.client_id = "your_client_id"
    #   config.access_token = "your_access_token"
    def initialize
      @client_id = nil
      @access_token = nil
      @base_url = nil
      @compact_csv_url = COMPACT_CSV_URL
      @detailed_csv_url = DETAILED_CSV_URL
    end

    # Return the resolved base URL
    def base_url
      # Priority:
      # 1. Explicitly set via config
      return @base_url if @base_url

      # 2. If Rails present and not production, use sandbox
      if defined?(Rails) && !Rails.env.production?
        SANDBOX_BASE_URL
      else
        LIVE_BASE_URL
      end
    end
  end
end
