file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
gem 'minitest'
require 'minitest'
class Test<MiniTest::Unit::TestCase
		include HtmlTag::NetshWlan

		def testshowall
				 rs = netsh_wlsh_all
				 rs.each do |item|
						item.each do |k, v|
								if v =="wifipublicfree"
										p item[:bssids]
								end
						end
				end
		end

		def testget_channel
				@ts_drb_pc2 = "druby://50.50.50.56:8787"
				DRb.start_service
				@wifi                = DRbObject.new_with_uri(@ts_drb_pc2)
				p @wifi.get_wlan_channel("wifipublicfree")
				p @wifi.ping("wwww.qq.com")
		end
		
		def test_getchannel
		   p get_wlan_channel("wifipublicfree")
		end 
end