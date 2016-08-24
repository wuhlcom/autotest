#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
# require file_path
require 'htmltags'
module Frame
		class MyTestString < MiniTest::Unit::TestCase
				include HtmlTag::ScreenShot
				include HtmlTag::LogInOut
				# Called before every ftp_test method runs. Can be used
				# to set up fixture information.
				def setup
						# Do nothing
				end

				def test_screenshot
						@browser     = Watir::Browser.new :ff, :profile => "default"
						@@default_url="192.168.100.1"
						img_path     = "d:/test.png"
						login(@browser, @@default_url)
						save_screenshot(@browser, img_path, time = Time.new.strftime("%Y%m%d%H%M%S"))
				end

				# Called after every ftp_test method runs. Can be used to tear
				# down fixture information.

				def teardown
						# Do nothing
				end


		end
end