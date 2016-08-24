#encoding:utf-8
gem 'minitest'
require 'minitest/autorun'
file_path =File.expand_path('../../lib/htmltags', __FILE__)
require file_path
# require 'htmltags'
module Frame
		class MyTestString < MiniTest::Unit::TestCase
				include HtmlTag::RouterOS
				# Called before every ftp_test method runs. Can be used
				# to set up fixture information.
				def setup
						# Do nothing
				end

				def test_routeos
						ip ="10.10.10.1"
						init_routeros_obj(ip)
						p "11111"
						pptp_set = "interface pptp-server server set authentication=pap,chap,mschap1,mschap2"
						# routeros_send_cmd(pptp_set)
						pptp_pri ="interface pptp-server server print"
						# p pptp_srv_pri(pptp_pri)
						logout_routeros
						######################class######################
						# obj      = HtmlTag::RouterOS.new(ip)
						pptp_set  = "interface pptp-server server set authentication=pap,chap,mschap1,mschap2"
						# obj.routeros_send_cmd(pptp_set)
						pptp_exp  ="interface pptp-server server export"
						# p obj.pptp_srv_exp(pptp_exp)
						pptp_pri  ="interface pptp-server server print"
						# p obj.pptp_srv_pri(pptp_pri)
						pppoe_set = "interface pppoe-server server set authentication=pap,chap,mschap1,mschap2 0"
						pppoe_set = "interface pppoe-server server set authentication=pap 0"
						# p obj.routeros_send_cmd(pppoe_set)
						pppoe_pri = "interface pppoe-server server print"
						# p obj.pppoe_srv_pri(pppoe_pri)
				end

				# Called after every ftp_test method runs. Can be used to tear
				# down fixture information.

				def teardown
						# Do nothing
				end


		end
end