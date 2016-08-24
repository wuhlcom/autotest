#encoding: utf-8
require 'watir-webdriver'
include Watir
require 'test/unit'
require 'test/unit/testsuite'
require 'test/unit/ui/console/testrunner'
Selenium::WebDriver::Firefox::Binary.path="D:/Program Files (x86)/Mozilla Firefox/firefox.exe"
class TC_recorded < Test::Unit::TestCase
  @browser = Watir::Browser.new
  p @browser.status
  @browser.goto('192.168.200.1')
  p @browser.status
  @browser.text_field(:name, 'admuser').set('admin')
  @browser.text_field(:name, 'admpass').set('admin')
  @browser.button(:value, '登录').click
  @browser.close
end