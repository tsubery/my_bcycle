$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "my_bcycle"
require "webmock/rspec"
require "vcr"

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "spec/cassettes"
end

ENV["BCYCLE_TEST_USER"] = "meeee"
ENV["BCYCLE_TEST_PASS"] = "notreally"
