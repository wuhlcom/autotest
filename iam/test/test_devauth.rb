#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'

file_path =File.expand_path('../../lib/iam', __FILE__)
require file_path
class MyTestString < MiniTest::Unit::TestCase
  # include IAMAPI::Manager
  # include IAMAPI::Oauth
  # Called before every ftp_test method runs. Can be used
  # to set up fixture information.
  def setup
    @iam_obj = IAMAPI::IAM.new
    # Do nothing
  end

  # Called after every ftp_test method runs. Can be used to tear
  # down fixture information.

  def teardown
    # Do nothing
  end

  def test_qca_app
    p rs = @iam_obj.manager_login #管理员登录->得到uid和token
    uid =rs["uid"]
    token=rs["token"]
    app_name = "test"
    p @iam_obj.get_app_files(app_name, token, uid)
  end

end