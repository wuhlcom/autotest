#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj          = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_tag_remote_p1       = 65534
				@tc_tag_remote_p2       = 9001
		end

		def process

				operate("1��DUT����������WAN��������ΪDHCP���������ȡ���ĵ�ַΪ10.10.0.100����                                                               2������Զ�̷��ʹ����ܣ�����Ȩ������Ϊ�κ��ˣ��˿�����Ϊ1���鿴ҳ����ʾ��Զ�̹����ַ��Ϣ�Ƿ�׼ȷ��") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "���ý��뷽ʽΪDHCP".to_gbk
						#�޸ķ�������Լ��WANҪ���»�ȡһ��IP��ַ������ֱ������DHCPģʽ������
						@wan_page.set_dhcp(@browser, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type  = sys_page.get_wan_type
						@wan_addr = sys_page.get_wan_ip
						puts "��ѯ��WAN���뷽ʽΪ#{wan_type}".to_gbk
						puts "��ѯ��WAN IPΪ#{@wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, @wan_addr, 'dhcp��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'
				}

				operate("2������Զ�̷��ʹ����ܣ��˿�Ϊ#{@tc_tag_remote_p1}���鿴ҳ����ʾ��Զ�̹����ַ��Ϣ�Ƿ�׼ȷ��") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@options_page.web_access_port=@tc_tag_remote_p1
						@options_page.save_web_access
				}

				operate("3������Զ�̷��ʹ����ܣ�PCͨ��WAN��IP��ַ#{@wan_addr}+���õ�Զ�̷��ʶ˿ں�#{@tc_tag_remote_p1}�Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棻") {
						remote_url = "#{@wan_addr}:#{@tc_tag_remote_p1}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "Զ��WEB����ʧ��!")
				}

				operate("4������Զ�̷��ʹ����ܣ�PCͨ��WAN��IP��ַ#{@wan_addr}+Ĭ��Զ�̶˿ں�#{@ts_remote_default_port}�Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棻") {
						remote_url = "#{@wan_addr}:#{@ts_remote_default_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						refute(rs, "�޸Ķ˿�Ϊ��Ĭ�Ϻ�,ʹ��Ĭ�϶˿�Ҳ��Զ��WEB����!")
				}

				operate("5������Զ�̷��ʹ����ܣ��˿�Ϊ#{@tc_tag_remote_p2}���鿴ҳ����ʾ��Զ�̹����ַ��Ϣ�Ƿ�׼ȷ��") {
						@options_page.web_access_port=@tc_tag_remote_p2
						@options_page.save_web_access
				}

				operate("6������Զ�̷��ʹ����ܣ�PCͨ��WAN��IP��ַ#{@wan_addr}+���õ�Զ�̷��ʶ˿ں�#{@tc_tag_remote_p2}�Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棻") {
						remote_url = "#{@wan_addr}:#{@tc_tag_remote_p2}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "Զ��WEB����ʧ��!")
				}

		end

		def clearup
				operate("1 �ر���������WEB����") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}
		end

}
