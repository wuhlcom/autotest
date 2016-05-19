#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.16", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_telnet_usr    = "root"
				@tc_telnet_pw     = "zl4321"
				@tc_signal_strong = "ǿ"
				@tc_dbm_strong    = "20"
				@tc_signal_middle = "��"
				@tc_dbm_middle    = "17"
				@tc_signal_weak   = "��"
				@tc_dbm_weak      = "14"
		end

		def process

				operate("1������߼�����-wifi�߼�����ҳ�棻") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
				}

				operate("2�������ź�ǿ��Ϊǿ��������棬�鿴�Ƿ񱣴�ɹ���STA�Ƿ����ӳɹ���") {
						sig = @wifi_page.wifi_signal
						puts "��ǰ�ź�ǿ������ֵΪ:#{sig}".to_gbk
						unless sig == @tc_signal_strong
								puts "�޸��ź�ǿ������ֵΪ:#{@tc_signal_strong}".to_gbk
								@wifi_page.modify_wifi_signal(@tc_signal_strong)
								@wifi_page.save_wifi_config
						end
						init_router_obj(@ts_default_ip, @tc_telnet_usr, @tc_telnet_pw)
						iwinfo = router_iwconfig
						logout_router
						signal = iwinfo[3]
						puts "��ѯ���ź�ǿ��Ϊ#{signal}dBm".to_gbk
						assert_equal(@tc_dbm_strong, signal, "�ź�ǿ�����ò���ȷ")
				}

				operate("3�������ź�ǿ��Ϊ�У�������棬�鿴�Ƿ񱣴�ɹ���STA�Ƿ����ӳɹ���") {
						@wifi_page.select_2g_advset
						sig = @wifi_page.wifi_signal
						puts "��ǰ�ź�ǿ������ֵΪ:#{sig}".to_gbk
						unless sig == @tc_signal_middle
								puts "�޸��ź�ǿ������ֵΪ:#{@tc_signal_middle}".to_gbk
								@wifi_page.modify_wifi_signal(@tc_signal_middle)
								@wifi_page.save_wifi_config
						end
						init_router_obj(@ts_default_ip, @tc_telnet_usr, @tc_telnet_pw)
						iwinfo = router_iwconfig
						logout_router
						signal = iwinfo[3]
						puts "��ѯ���ź�ǿ��Ϊ#{signal}dBm".to_gbk
						assert_equal(@tc_dbm_middle, signal, "�ź�ǿ�����ò���ȷ")
				}

				operate("4�������ź�ǿ��Ϊ����������棬�鿴�Ƿ񱣴�ɹ���STA�Ƿ����ӳɹ���") {
						@wifi_page.select_2g_advset
						sig = @wifi_page.wifi_signal
						puts "��ǰ�ź�ǿ������ֵΪ:#{sig}".to_gbk
						unless sig == @tc_signal_weak
								puts "�޸��ź�ǿ������ֵΪ:#{@tc_signal_weak}".to_gbk
								@wifi_page.modify_wifi_signal(@tc_signal_weak)
								@wifi_page.save_wifi_config
						end
						init_router_obj(@ts_default_ip, @tc_telnet_usr, @tc_telnet_pw)
						iwinfo = router_iwconfig
						logout_router
						signal = iwinfo[3]
						puts "��ѯ���ź�ǿ��Ϊ#{signal}dBm".to_gbk
						assert_equal(@tc_dbm_weak, signal, "�ź�ǿ�����ò���ȷ")
				}

		end

		def clearup
				operate("1 �ָ�Ĭ���ź�ǿ������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_advance(@browser.url)
						unless @wifi_page.wifi_signal == @tc_signal_strong
								@wifi_page.modify_wifi_signal(@tc_signal_strong)
								@wifi_page.save_wifi_config
						end
				}
		end

}
