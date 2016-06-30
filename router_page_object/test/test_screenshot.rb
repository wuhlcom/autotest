#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def test_login
				url      = "192.168.100.1"
				usrname  = "admin"
				passwd   = "admin"
				@browser = Watir::Browser.new :firefox, :profile => "default"
				# @browser.cookies.clear
				login_router = RouterPageObject::LoginPage.new(@browser)

				dir       = File.dirname(__FILE__)
				image_dir = "#{dir}/image"
				unless File.exists?(image_dir)
						Dir.mkdir(image_dir)
				end

				#登录
				login_router.login_with(usrname, passwd, url)
				image_path = "#{image_dir}/login2.png"
				login_router.save_screenshot(image_path)
		end

end