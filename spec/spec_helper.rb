# frozen_string_literal: true

require "dhanhq"
require "vcr"
require "webmock/rspec"

require_relative "support/dhanhq_helper"
require_relative "support/json_helper"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # config.expect_with :rspec do |c|
  #   c.syntax = :expect
  # end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include DhanhqHelper
  config.include JsonHelper
end

# VCR.configure do |c|
#   c.cassette_library_dir = "spec/vcr_cassettes"
#   c.hook_into :webmock
#   c.filter_sensitive_data("<ACCESS_TOKEN>") { ENV.fetch("ACCESS_TOKEN", nil) }
# end

WebMock.disable_net_connect!(allow_localhost: true)
