#encoding: utf-8
require 'watir-webdriver'
require 'test/unit'
class TC_recorded < Test::Unit::TestCase
		@browser = Watir::Browser.new :ff, :profile => "default"
		p @browser.goto("192.168.100.1")
		tag_lan="set_wifi"
		p @browser.span(:id => tag_lan).wait_until_present(2)
# 	p @browser.text_field(:name, 'admuser').exists?
# 	@browser.text_field(:name, 'admuser').set('admin')
# 	@browser.text_field(:name, 'admpass').set('admin')
# 	@browser.button(:value, '登录').click
# 	sleep 10
# 	p "1111"
# 	@browser.goto("192.168.111.1")
# sleep 5
# wait_until_present
# 	p @browser.span(:id => 'set_network').exists?
# @browser.span(:id => 'set_network').click
# p @browser.iframe.exists?
# @browser.iframe.span(:id => 'wireless').click
# @browser.iframe.span(:id => 'wire').click
# @browser.span(:id => 'wireless').click
#   @browser.close
# end
# end
end
