# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles the Kill Switch API to manage trading status for the current trading day.
    class KillSwitch < Base
      class << self
        # Activate or deactivate the Kill Switch for the account.
        #
        # @param status [String] The Kill Switch status, either 'ACTIVATE' or 'DEACTIVATE'
        # @return [Hash] Response from the API with Kill Switch status
        #
        # @example Activate Kill Switch:
        #   kill_switch.manage("ACTIVATE")
        #
        # @example Deactivate Kill Switch:
        #   kill_switch.manage("DEACTIVATE")
        def manage(status)
          raise ArgumentError, "Invalid status. Use 'ACTIVATE' or 'DEACTIVATE'" unless %w[
            ACTIVATE
            DEACTIVATE
          ].include?(status)

          request(:post, "/killswitch?killSwitchStatus=#{status}")
        end
      end
    end
  end
end
