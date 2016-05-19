#encoding:utf-8
file_path1 =File.expand_path("../htmltagobj", __FILE__)
file_path2 =File.expand_path("../wincmd", __FILE__)
require file_path1
require file_path2
module HtmlTag
  module HtmlTagEnv
    def login(usrname="admin", passwd="admin", url=@default_url)
      if WinCmd.ping(url)
        @browser.goto(url)
        @browser.text_field(:name, 'admuser').set('admin')
        @browser.text_field(:name, 'admpass').set('admin')
        @browser.button(:value, '登录').click
      else
        raise("Err:Ping Router Failed")
      end
    end

    def logout
      @browser.close
    end

    def set

    end

    def click

    end

  end
end