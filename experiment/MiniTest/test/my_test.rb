# require 'ftp_test/unit'

gem 'minitest'
require 'minitest/autorun'
# class MyTest1 < MiniTest::Unit
class MyTest1 < MiniTest::Unit::TestCase #Test::Unit::TestCase
  parallelize_me!
  i_suck_and_my_tests_are_order_dependent!
  # Called before every ftp_test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  def test_1
    assert_equal 1, 2, "11111111111111111111111"
  end

  def test_2
    assert_equal 1, 3, "222222222222222222222222"
  end

  def test_3
    assert_equal 1, 4, "3333333333333333333333333"
  end

  def test_4
    assert_equal 1, 5, "4444444444444444444444444"
  end

  def test_5
    assert_equal 1, 6, "555555555555555555555"
  end

  # Called after every ftp_test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  # Fake ftp_test
  # def test_fail
  #
  #   fail('Not implemented')
  # end
end