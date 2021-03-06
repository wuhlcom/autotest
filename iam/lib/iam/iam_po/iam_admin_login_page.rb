#encoding:utf-8
#router login page tags
#login in router
#date:2016-02-24
#author:wuhongliang
file_path1 =File.expand_path('../iam_tag_value', __FILE__)
require file_path1
module IamPageObject
  module Login_Page
    include PageObject
    text_field(:usrname, id: @@ts_tag_admin_usr)
    text_field(:passwd, id: @@ts_tag_admin_pw)
    text_field(:yzcode, id: @@ts_tag_admin_yz)
    image(:imcode, id: @@ts_tag_admin_imcode)
    button(:submit, id: @@ts_tag_admin_login)
  end

  class LoginPage
    include Login_Page

    def login(username, password, url, yzcode=nil)
      self.navigate_to url
      sleep 2
      self.usrname = username
      self.passwd  = password
      self.yzcode  = yzcode if !yzcode.nil?
      self.submit
      sleep 5
    end

    #判断登录界面是否存在
    def login?(url)
      usrname?
    end
  end

end