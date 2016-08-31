#encoding: utf-8
gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
file_path =File.expand_path('../../lib/router_page_object', __FILE__)
require file_path
# require 'router_page_object'

class Test<MiniTest::Unit::TestCase
		def test_set_pw1
				@ts_download_directory = File.expand_path("../webdownloads", __FILE__)
				p @ts_download_directory.gsub!("/", "\\\\") #if Selenium::WebDriver::Platform.windows?
		end
end
