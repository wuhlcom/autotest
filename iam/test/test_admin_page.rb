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

  def test_login
    @browser = Watir::Browser.new :ff, :profile => "default"
    # url      ="wwww.baidu.com"
    # p @browser.goto(url)
    loginobj = IamPageObject::LoginPage.new(@browser)
    usr      ="admin2@zhilutec.com"
    pw       ="123123"
    code     ="1234"
    url      = "http://192.168.10.9:8080/index.php/Login/index.html"
    p loginobj.login(usr, pw, url, code)
  end

  def test_table_link_click
    appname  = "IAM_F_DeviceOperation_013"
    usr      ="admin2@zhilutec.com"
    pw       ="123123"
    code     ="1234"
    url      = "http://192.168.10.9:8080/index.php/Login/index.html"
    @browser = Watir::Browser.new :ff, :profile => "default"
    loginobj = IamPageObject::FucList.new(@browser)
    loginobj.login(usr, pw, url, code)
    link = loginobj.app_config(appname)
    p link.exists?
    link.click
  end

  def test_upload_file
    appname  = "IAM_F_DeviceOperation_013"
    usr      ="admin2@zhilutec.com"
    pw       ="123123"
    code     ="1234"
    url      = "http://192.168.10.9:8080/index.php/Login/index.html"
    @browser = Watir::Browser.new :ff, :profile => "default"
    loginobj = IamPageObject::FucList.new(@browser)
    loginobj.login(usr, pw, url, code)
    file ="E:\\autotest\\iam_testcases\\process_files\\autotest_01.ko"
    # loginobj.get_iframe_obj(appname)
    loginobj.set_app_file(appname, file)
  end

  def test_delete_appfile
    appname  = "IAMAPI_IAM_F_OAuth_019"
    usr      ="admin2@zhilutec.com"
    pw       ="123123"
    code     ="1234"
    url      = "http://192.168.10.9:8080/index.php/Login/index.html"
    @browser = Watir::Browser.new :ff, :profile => "default"
    loginobj = IamPageObject::FucList.new(@browser)
    loginobj.login(usr, pw, url, code)
    file ="E:\\autotest\\iam_testcases\\process_files\\autotest_01.ko"
    loginobj.set_app_file(appname, file)
    loginobj.delete_app_file(appname, file)
  end

end