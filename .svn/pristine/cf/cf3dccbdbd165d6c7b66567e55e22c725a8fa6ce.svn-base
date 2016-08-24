#encoding:utf-8
require 'watir-webdriver'
#$firfox_path ="D:/Program Files (x86)/Mozilla Firefox/firefox.exe"
module HtmlTag

  class Browser
    def initialize(url="192.168.100.1")
      # Selenium::WebDriver::Firefox::Binary.path=$firfox_path
      @browser = Watir::Browser.new
      @default_url = url
    end

    def browser(args=nil)
      #Selenium::WebDriver::Firefox::Binary.path=$firfox_path
      Watir::Browser.new
    end

    def goto(url=@default_url)
      @browser.goto(url)
    end

    def text_field(args)
      @text_filed=self.goto(args[:url])
      @text_filed.text_field(args[:name], args[:value])
    end

    def button(args)
      # @browser.button(:value, '登录').click
      @button=self.goto(args[:url])
      @button.button(args[:value], args[:value_v])
    end
  end

end