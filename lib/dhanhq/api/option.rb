# frozen_string_literal: true

require_relative "../contracts/option_chain_contract"
require_relative "../contracts/expiry_list_contract"

module Dhanhq
  module API
    # Provides methods to interact with option data via Dhanhq's API.
    #
    # The `Option` class extends `Dhanhq::API::Base` and includes methods to:
    # - Retrieve the Option Chain data.
    # - Retrieve the Expiry List for a given underlying security.
    #
    # Example usage:
    #   # Fetch the Option Chain
    #   option_chain = Option.chain({
    #     UnderlyingScrip: 12345,
    #     UnderlyingSeg: "NSE_FNO",
    #     Expiry: "2024-12-31"
    #   })
    #
    #   # Fetch the Expiry List
    #   expiry_list = Option.expiry_list({
    #     UnderlyingScrip: 12345,
    #     UnderlyingSeg: "NSE_FNO"
    #   })
    #
    # @see Dhanhq::API::Base For shared API methods.
    # @see Dhanhq::Contracts::OptionChainContract For Option Chain validation.
    # @see Dhanhq::Contracts::ExpiryListContract For Expiry List validation.
    # @see https://dhanhq.co/docs/v2/option-chain/ Dhanhq API Documentation
    class Option < Base
      class << self
        # Fetches the Option Chain data for a given underlying instrument.
        #
        # @param params [Hash] The request parameters for the Option Chain.
        #   Required keys:
        #   - `UnderlyingScrip` [Integer] Security ID of the underlying instrument.
        #   - `UnderlyingSeg` [String] Exchange & segment of the underlying (e.g., "IDX_I").
        #   - `Expiry` [String] Expiry date in `YYYY-MM-DD` format.
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Fetch the Option Chain:
        #   option_chain = Option.chain({
        #     UnderlyingScrip: 13,
        #     UnderlyingSeg: "IDX_I",
        #     Expiry: "2024-10-31"
        #   })
        def chain(params)
          validated_params = validate_with(Dhanhq::Contracts::OptionChainContract, params)
          post("/v2/optionchain", validated_params)
        end

        # Fetches the Expiry List for a given underlying instrument.
        #
        # @param params [Hash] The request parameters for the Expiry List.
        #   Required keys:
        #   - `UnderlyingScrip` [Integer] Security ID of the underlying instrument.
        #   - `UnderlyingSeg` [String] Exchange & segment of the underlying (e.g., "IDX_I").
        #
        # @return [Hash] The API response as a parsed JSON object.
        # @raise [Dhanhq::Error] If validation fails or the API returns an error.
        #
        # @example Fetch the Expiry List:
        #   expiry_list = Option.expiry_list({
        #     UnderlyingScrip: 13,
        #     UnderlyingSeg: "IDX_I"
        #   })
        def expiry_list(params)
          validated_params = validate_with(Dhanhq::Contracts::ExpiryListContract, params)
          post("/v2/optionchain/expirylist", validated_params)
        end
      end
    end
  end
end
