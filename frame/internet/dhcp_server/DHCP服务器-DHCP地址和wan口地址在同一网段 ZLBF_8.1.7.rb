#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.7", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_lan_time   = 35
				@tc_error_info = "IP ��������WAN�ں�LAN�ڲ�������ͬһ����"

		end

		def process

				operate("1����½·���������������ã�") {
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						wan_page.set_dhcp(@browser, @browser.url)
						#��һ�β�ѯ״̬
						sys_page.open_systatus_page(@browser.url)
						@tc_wan_ip = sys_page.get_wan_ip
						puts "��ѯ��WAN IPΪ#{@tc_wan_ip}".to_gbk
						assert_match(@ts_tag_ip_regxp, @tc_wan_ip, "WAN��δ��ȡ��IP��ַ")
				}

				operate("2��DHCP��ַ�����wan�ڵ�ַ��ͬһ�Σ�") {
						ip_arr = @tc_wan_ip.split(".")
						if ip_arr.last.to_i<254
								new_serverip=@tc_wan_ip.succ
						else
								new_serverip=@tc_wan_ip.sub(/\.\d+$/, ".20")
						end
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@lan_page.lan_ip_set(new_serverip)
						@lan_page.save_lanset
				}

				operate("3���������") {
						error_info = @lan_page.lan_error
						puts "ERROR TIP:#{error_info}".encode("GBK")
						if @tc_error_info==error_info
								assert_equal(@tc_error_info, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")
						else
								assert(false, "��ַ�����ô�����ʾ���ݲ���ȷ")
								sleep @tc_lan_time
						end
				}


		end

		def clearup

		end

}
