require_relative "../lib/hyper_traverser"

require 'rspec'
require 'mocha'
require 'awesome_print'
require 'pry'

RSpec.configure do |config|
  config.mock_framework = :mocha
end
