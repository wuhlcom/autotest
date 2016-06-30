#
# description:
# pc2 Զ�̵�¼��δʵ��
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj = DRbObject.new_with_uri(@ts_drb_server2)
		end

		def process

				operate("1��DUT����������WAN��������ΪDHCP���������ȡ���ĵ�ַΪ10.10.0.100����") {
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

				operate("2������Զ�̷��ʹ����ܣ�����Ȩ������Ϊ�κ��ˣ��˿�ΪĬ��ֵ���鿴ҳ����ʾ��Զ�̹����ַ��Ϣ�Ƿ�׼ȷ��") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access
				}

				operate("3��PC2ͨ��WAN��IP��ַ+���õ�Զ�̷��ʶ˿ں��Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棨ע���¼��֤�Ի������ʾ�ַ��ĺϷ�/��ȷ�ԣ��粻����ʾ�쳣�ַ�ͼƬ�򲻷��ϵ�ǰ�ͻ����ַ�ͼƬ����") {
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "Զ��WEB����ʧ��!")
				}

				operate("4������������һ̨����PC3ͨ��WAN��IP��ַ+���õ�Զ�̷��ʶ˿ں��Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棻") {
						#pending
				}

				operate("5��PC2ͨ��WAN��IP��ַ+�����õ�Զ�̷��ʶ˿ں��Ƿ��ܷ��ʵ�DUT��WEB����ҳ�档") {
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port.succ!}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						refute(rs, "����Ķ˿�Ҳ��Զ��WEB����!")
				}

		end

		def clearup
				operate("1 �ر���������WEB����") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}
		end

}
