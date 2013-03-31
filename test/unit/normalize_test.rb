require 'test_helper'
require 'helpers'

class NormalizeTest < UnitTest
  def setup
    @helper = Object.new.tap { |o| o.extend Helpers }
  end
  
  def test_basic_example
    numbers = (1..100).map { |i| [i, i] }.sort_by(&:last)
    normalized = numbers.map { |pair| [pair.first, @helper.normalize(pair.last, 100)] }.sort_by(&:last)
    
    assert_equal(numbers.map(&:first), normalized.map(&:first))
    assert(normalized.map(&:last).all? { |i| (1..100).include?(i) })
  end
  
  def test_maximum
    assert_equal(100, @helper.normalize(10, 10))
  end
  
  def test_zero
    assert_equal(0, @helper.normalize(0, 10))
  end
  
  def test_maximum_1
    assert_equal(100, @helper.normalize(1, 1))
    assert_equal(0, @helper.normalize(0, 1))
  end
end