ENV['RACK_ENV'] = 'test'

require 'minitest/unit'
require 'minitest/autorun'

module TestHelper
end

class UnitTest < MiniTest::Unit::TestCase
  include TestHelper
end
