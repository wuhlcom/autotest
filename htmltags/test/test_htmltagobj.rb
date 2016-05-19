file_path =File.expand_path('../../lib/htmltagObj', __FILE__)
require file_path
require 'test/unit'
class MyTest < Test::Unit::TestCase
  # Called before every ftp_test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  def test_obj
    HtmlTag::Browser.new
    assert_equal "1","1"
end

  # def test_obj
  #   p  HtmlTag::Browser.new
  # end
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