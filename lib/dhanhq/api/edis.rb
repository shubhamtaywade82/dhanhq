# frozen_string_literal: true

module Dhanhq
  module Api
    # Handles endpoints related to eDIS, including T-PIN generation, form generation,
    # and inquiry for eDIS approval status.
    #
    # @example Generate T-PIN:
    #   client = Dhanhq::Client.new
    #   edis = client.edis
    #   response = edis.generate_tpin
    #
    # @example Generate eDIS Form:
    #   response = edis.generate_form({
    #     isin: 'INE733E01010',
    #     qty: 1,
    #     exchange: 'NSE',
    #     segment: 'EQ',
    #     bulk: true
    #   })
    #
    # @example Inquire eDIS Status:
    #   response = edis.inquire_status('INE733E01010')
    class Edis < BaseApi
      class << self
        # Generate a T-PIN on the registered mobile number.
        #
        # @return [String] Response status (e.g., '202 Accepted')
        #
        # @example Generate T-PIN:
        #   edis.generate_tpin
        def generate_tpin
          request(:get, "/edis/tpin")
        end

        # Generate an escaped HTML form for CDSL eDIS approval.
        #
        # @param params [Hash] The request payload for generating the eDIS form
        # @return [Hash] Response containing the escaped HTML form
        #
        # @example Generate eDIS Form:
        #   edis.generate_form({
        #     isin: 'INE733E01010',
        #     qty: 1,
        #     exchange: 'NSE',
        #     segment: 'EQ',
        #     bulk: true
        #   })
        def generate_form(params)
          Dhanhq::Helpers::Validator.validate_presence(params, %i[isin qty exchange segment])
          request(:post, "/edis/form", params)
        end

        # Inquire the eDIS approval status of a stock using its ISIN.
        #
        # @param isin [String] ISIN of the stock or 'ALL' for all holdings
        # @return [Hash] Response containing the approval status of the stock
        #
        # @example Inquire eDIS Status:
        #   edis.inquire_status('INE733E01010')
        def inquire_status(isin)
          request(:get, "/edis/inquire/#{isin}")
        end
      end
    end
  end
end
