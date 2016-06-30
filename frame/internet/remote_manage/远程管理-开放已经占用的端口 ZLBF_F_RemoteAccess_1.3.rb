#
# description:
# 1.������������������ʵĶ˿���ͬʱ��������������
# author:wuhlcom
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.3", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj   = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_dut_ip       = ipconfig("all")[@ts_nicname][:ip][0] #��ȡdut����ip
				@tc_wait_time    = 3
				@tc_private_port = "80"
				@tc_content      = "HTTP AutoTest"

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
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2������Զ�̷��ʹ����ܣ�����Ȩ������Ϊ�κ��ˣ��˿�ΪĬ��ֵ") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_web_access_btn(@browser.url)
						@tc_web_acc_port = @options_page.web_access_port
						@options_page.save_web_access(15)
				}

				operate("3��PC2ͨ��WAN��IP��ַ+���õ�Զ�̷��ʶ˿ں��Ƿ��ܷ��ʵ�DUT��WEB����ҳ�棻") {
						remote_url = "#{@wan_addr}:#{@tc_web_acc_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "Զ��WEB����ʧ��!")
				}

				operate("4������������������ܣ���ӹ���ת���˿�����Ϊ2000-3000���������ã�") {
						puts "���������IPΪ#{@tc_dut_ip},����˿�#{@tc_web_acc_port},�������˿�#{@tc_private_port}".to_gbk
						@options_page.open_vps_step(@browser.url)
						@options_page.add_vps
						@options_page.vps_input(@tc_dut_ip, @tc_web_acc_port, @tc_private_port)
						@options_page.save_vps
				}

				operate("5���޸�Զ�̷��ʹ���˿�Ϊ2000-3000֮�������˿ڣ��Ƿ������óɹ���") {
						puts "�������������".to_gbk
						http_server(@wan_addr, @tc_private_port, @tc_content)
						rs = @tc_server_obj.tcp_client(@wan_addr, @tc_web_acc_port)
						refute(rs.tcp_state, "���������������ʹ��ͬһ�˿�ʱ������������ܷ���")
				}


		end

		def clearup

				operate("1,�ر�Զ�̷��ʹ���") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.close_web_access(@browser.url)
				}

				operate("2,ɾ���������������") {
						@options_page.open_vps_step(@browser.url)
						@options_page.delete_all_vps
						@options_page.close_vps_btn
						@options_page.save_vps
				}

		end

}
