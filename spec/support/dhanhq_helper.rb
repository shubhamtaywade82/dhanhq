# frozen_string_literal: true

module DhanhqHelper
  def configure_dhanhq
    Dhanhq.configure do |config|
      config.base_url = "https://api.dhan.co/v2"
      config.client_id = "test_client_id"
      config.access_token = "test_access_token"
    end
  end
end
