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

  #手机用户注册
  def test_phone_reg
    pho= "14400004444"
    # pho = "13760281579"
    pw = "123456"
    p @iam_obj.register_phoneusr(pho, pw)
  end

  #手机用户修改密码
  def test_modpwd_mobile
    pho = "14400004444"
    # pho = "13760281579"
    pw  = "1234567"
    p @iam_obj.usr_modpw_mobile pho, pw
  end

  def test_get_usr_app_all
    usr="13760281579"
    pwd="123456"
    p rs=@iam_obj.user_login(usr, pwd)
    uid  =rs["uid"]
    token=rs["access_token"]
    p @iam_obj.user_app_list_all(uid, token)
  end

  def test_get_usr_app_bytype
    usr  ="13760281579"
    pwd  ="123456"
    # p rs=@iam_obj.user_login(usr, pwd)
    # uid  =rs["uid"]
    # token=rs["access_token"]
    cond = "test"
    p @iam_obj.usr_login_list_app_bytype(usr, pwd, false, cond)
  end

  def test_get_usr_app_name
    usr="13760281570"
    pwd="123456"
    app="test_app"
    p rs=@iam_obj.user_login(usr, pwd)
    # uid  =rs["uid"]
    # token=rs["access_token"]
    # p @iam_obj.user_app_list_bytype(app, uid, token)
  end

  def test_ubinding_app
    usr  ="13760281579"
    pwd  ="123456"
    app  ="test_app"
    rs   =@iam_obj.user_login(usr, pwd)
    uid  =rs["uid"]
    token=rs["access_token"]
    p @iam_obj.qub_app(app, uid, token)
  end

  def test_binding_app
    usr  ="13760281579"
    pwd  ="123456"
    app  ="test_app"
    rs   =@iam_obj.user_login(usr, pwd)
    uid  =rs["uid"]
    token=rs["access_token"]
    p @iam_obj.qb_app(app, uid, token)
  end

  def test_find_pwd_for_email
    usr  ="378433855@qq.com"
    pw   = "123456"
    newpw="123123"
    # @iam_obj.register_emailusr(usr, pw, 1)
    # p @iam_obj.find_pwd_for_email(usr)
    # p @iam_obj.usr_find_mod_emailpw(usr, newpw)
    # p rs =@iam_obj.user_login(usr, newpw)
  p  @iam_obj.usr_delete_usr(usr, newpw)
  end
  # Fake ftp_test
  # def test_fail
  #
  #   fail('Not implemented')
  # end

end