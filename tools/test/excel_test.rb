require 'test/unit'
File.dirname(__FILE__)=~/(.+)\/ftp_test/i
path=$1
require  $1+"/parser_excel_tc.rb"
file="E:/Automation/V100R003�汾�Զ�����������.xls"
class MyTest < Test::Unit::TestCase

  # Called before every ftp_test method runs. Can be used
  # to set up fixture information.
  def setup
    # Do nothing
  end

  def test_excel

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