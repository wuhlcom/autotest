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

  def test_manager_login
    admin ="klwnkk@163.com"
    pw    ="123456"
    # p rs    = @iam_obj.manager_login(admin, pw) #管理员登录->得到uid和token
    #  assert_equal(admin, rs["name"], "manager name error!")
    p rs = @iam_obj.manager_login #管理员登录->得到uid和token
  end

  def test_get_app_info
    p rs = @iam_obj.manager_login #管理员登录->得到uid和token
    uid    = rs["uid"]
    token  =rs["token"]
    appname="test_app"
    p @iam_obj.get_spec_app_info(token, appname, uid)
  end

  def test_code
    @iam_obj.mana_create_app(args)
    @iam_obj.oauth_get_code(appname)
  end

  def test_get_usr_all
    pp @iam_obj.get_mlist_all
  end

  def test_get_mlist_byname
    # @tc_account1 = "378433855@qq.com"
    # passwd  = "123456"
    # nickname="hahaha"
    @tc_account1   = "admin@zhilutec.com"
    @tc_account2   = "zhupai@zhilutec.com"
    @tc_query_str1 = "西瓜"
    @tc_passwd     = "123123"
    # p @iam_obj.manager_del_add(account, passwd, nickname)
    # @tc_man_name    = "admin@zhilutec.com"
    # @tc_passwd      = "123123"
    print @iam_obj.get_mlist_byname(@tc_query_str1, @tc_account1, @tc_passwd, true)
  end

  def test_del_manager
    @tc_man_name    = "managertest@zhilutec.com"
    @tc_subman_name = "wuhongliang@zhilutec.com"
    @tc_passwd      = "zhilutec"
    p @iam_obj.del_manager(@tc_subman_name)
  end

  def test_manager_add
    admin_usr= "wuhongliang@zhilutec.com"
    admin_pw = "123456"
    # usr      ="klwn202233@163.com"
    nickname = "autotest"
    comments = "1111"
    # print @iam_obj.manager_add(admin_usr, nickname, admin_pw)
    p @iam_obj.manager_add(admin_usr, nickname, admin_pw)
  end

  def test_manager_add_err
    str           = "ＺＨＩＬＵ".encode("utf-8")
    @tc_man_name1 = "#{str}@zhilutec.com"
    @tc_nickname  = "autotest_whl"
    @tc_passwd    = "123456"
    puts "添加超级管理员账户为:#{@tc_man_name1}".to_gbk
    print rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname, @tc_passwd)
    # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
    puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
    puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
    puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
  end

  def test_mobile_manager_modpw()
    phone    = "18900001111"
    mod_pw   = "123456222"
    nickname = "123456"
    p @iam_obj.mobile_manager_modpw(phone, mod_pw, nickname)
  end

  def test_mobile_modpw
    phone = "18900001111"
    p @iam_obj.request_mobile_code(phone)
  end

  def test_em_token
    account = "378433855@qq.com"
    passwd  = "123456"
    nickname="hahaha"
    p @iam_obj.manager_del_add(account, passwd, nickname)
    p @iam_obj.get_em_token(account)
  end

  def test_modify_empw
    account = "378433825@qq.com"
    passwd  = "1234567"
    modpw   = "45678944"
    nickname= "hahaha"
    p @iam_obj.manager_add_login(account, passwd, nickname)
    p @iam_obj.modify_emailmana_pw(account, modpw)
  end

  def test_create_app
    args ={"name"         => "newapp1",
           "provider"     => "provider",
           "redirect_uri" => "http://192.168.10.9",
           "comments"     => "comments"}
    p @iam_obj.mana_create_app(args)
  end

  def test_edit_submana_info
    admin_usr = "wuhongliang@zhilutec.com"
    admin_pw  = "123456"
    account   = "submanager@zhilutec.com"
    args      ={"nickname" => "subma1", "comments" => "subma1"}
    p @iam_obj.edit_submana_info(account, args, admin_usr, admin_pw)
  end

  def test_edit_mana_info
    admin_usr = "wuhongliang@zhilutec.com"
    admin_pw  = "123456"
    args      ={"nickname" => "myself", "comments" => "myself"}
    p @iam_obj.edit_mana_info(args, admin_usr, admin_pw)
  end

  def test_mana_modpw
    usr      ="klwnkk@163.com"
    nickname = "autotest"
    oldpw    ="123456"
    newpw    ="654321"
    # p @iam_obj.manager_add(usr, nickname, oldpw)
    p @iam_obj.mana_modpw(oldpw, newpw, usr)
  end

  def test_mana_mod_app
    appname = "newapp_test"
    provider="wo"
    re_uri  = "http://www.baidu.com"
    comments="a test"
    args1   = {"name": "newapp_test1", "provider": provider, "redirect_uri": re_uri, "comments": comments}
    p @iam_obj.mana_mod_app(appname, args1)
  end

  # Fake ftp_test
  # def test_fail
  #
  #   fail('Not implemented')
  # end
  def test_active_app
    appname = "IAMAPI_IAM_F_OAuth_019"
    status  = "1"
    p @iam_obj.mana_active_app(appname, status)
  end

  def test_qca_app
    app  = "test_app3"
    args ={"name" => app, "provider" => "whl", "redirect_uri" => "http://192.168.10.9", "comments" => "whl"}
    p @iam_obj.qca_app(app, args, "1")
  end

  def test_mana_modpw
    admin_usr = "wuhongliang@zhilutec.com"
    admin_pw  = "123456"
    newpw     = "12345678"
    p @iam_obj.mana_modpw(newpw, admin_pw, admin_usr)
  end

end