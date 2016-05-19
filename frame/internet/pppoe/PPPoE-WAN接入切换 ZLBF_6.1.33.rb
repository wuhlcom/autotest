#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.33", "level" => "P1", "auto" => "n"}

		def prepare

				DRb.start_service
				@tc_server_obj    = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_tag_link_href = "pptp.asp"
				@tc_tag_li_class  = "active"
				@tc_tag_ul_id     = "safe_ul"
				@tc_domain        = "www.baidu.com"
				@tc_net_time      = 60
				@tc_wait_time     = 2
				@tc_status_time   = 5
				@tc_cap_fields    = "-e frame.number -e eth.dst -e eth.src -e pppoe.code"
				@tc_pppoe_filter  = "pppoed && pppoe.code == 0x000000a7" #PADT code
				@tc_pppoe_args    = {nic: @ts_server_lannic, filter: @tc_pppoe_filter, duration: @tc_net_time, fields: @tc_cap_fields}
				puts "Capture filter PADT: #{@tc_pppoe_filter}"
		end

		def process

				operate("1����BAS����ץ����") {

				}

				operate("2������DUT��WAN���ŷ�ʽΪPPPoE��DNSΪ�Զ���ȡ��ʽ����֤������Ϊ�Զ�������д��ȷ�Ĳ����û��������룬�ύ���鿴�����Ƿ�ɹ�") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'

						rs = ping(@tc_domain)
						assert(rs, "�޷���������")
				}

				operate("3���л�DUT��WAN��ʽΪDHCP��ʽ��BASץ��ȷ���л���DHCPʱ���Ƿ���LCP Termination��PADT��ֹ��ǰPPPoE���ӣ����л���PPPoE��ʽ���Ƿ��ܿ��ٲ��ųɹ���") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						puts "��PPPOE�л���DHCPģʽ".to_gbk
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end

								#�л�Ϊdhcp
								@wan_page.set_dhcp_mode(@browser.url)

								@sys_page.open_systatus_page(@browser.url)
								p wan_addr     = @sys_page.get_wan_ip
								p wan_type     = @sys_page.get_wan_type
								assert_match @ip_regxp, wan_addr, 'DHCP��ȡip��ַʧ�ܣ�'
								assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '�������ʹ���'

								thr.join if thr.alive?
						rescue => ex
								p ex.message.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#���capture_rs��Ϊ��˵��ץ���˱���
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "δץ��PADT����")
						rs = ping(@tc_domain)
						assert(rs, "dhcp��ʽ�޷���������")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#�л���pppoe����
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'

						rs = ping(@tc_domain)
						assert(rs, "��DHCP�лص�PPPOE�޷���������")
				}

				operate("4���л�DUT��WAN��ʽ�ֱ�ΪSTATIC��L2TP��PPTP���������뷽ʽ���ظ�����3��ȷ�Ͻ����") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#�л�����̬IP
						puts "��PPPOE�л�����̬IPģʽ".to_gbk
						puts "��̬IPģʽ��ַΪ��#{@ts_staticIp}".to_gbk
						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end
								#�л�Ϊstatic
								@wan_page.set_static(@ts_staticIp, @ts_staticNetmask, @ts_staticGateway, @ts_staticPriDns, @browser.url)

								@sys_page.open_systatus_page(@browser.url)
								p wan_addr     = @sys_page.get_wan_ip
								p wan_type     = @sys_page.get_wan_type
								assert_match @ip_regxp, wan_addr, '��̬ip��ַ����ʧ�ܣ�'
								assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'
								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#���capture_rs��Ϊ��˵��ץ���˱���
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "δץ��PADT����")
						rs = ping(@tc_domain)
						assert(rs, "��̬��ʽ�޷���������")

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						#�л���pppoe����
						@wan_page.set_pppoe(@ts_pppoe_usr, @ts_pppoe_pw, @browser.url)

						@sys_page.open_systatus_page(@browser.url)
						p wan_addr     = @sys_page.get_wan_ip
						p wan_type     = @sys_page.get_wan_type
						assert_match @ip_regxp, wan_addr, 'PPPOE��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						rs = ping(@tc_domain)
						assert(rs, "��static�лص�PPPOE�޷���������")

						puts "��PPPOEģʽ�л�ΪPPTPģʽ".encode("GBK")
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						puts "���÷Ƿ���pptp�ʻ�".to_gbk
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_usr}"

						capture_rs = []
						begin
								thr = Thread.new do
										capture_rs = @tc_server_obj.tshark_display_filter_fields(@tc_pppoe_args)
								end
								#�л�Ϊdhcp
								puts "set pptp mode from pppoe waiting for net reset..."
								@options_page.set_pptp(@ts_pptp_server_ip,@ts_pptp_usr,@ts_pptp_usr,@browser.url) #����pptp����

								@sys_page.open_systatus_page(@browser.url)
								p wan_addr     = @sys_page.get_wan_ip
								p wan_type     = @sys_page.get_wan_type
								assert_match @ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�'
								assert_match /#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���'

								thr.join if thr.alive?
						rescue => ex
								p ex.messge.to_s
								assert(false, "Capture PADT Packets ERROR")
						end
						#���capture_rs��Ϊ��˵��ץ���˱���
						puts "Capture Result: #{capture_rs}"
						refute(capture_rs.empty?, "δץ��PADT����")
						rs = ping(@tc_domain)
						assert(rs, "pptp��ʽ�޷���������")
				}


		end

		def clearup

				operate("1 �ָ�Ĭ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						wan_page = RouterPageObject::WanPage.new(@browser)
						wan_page.set_dhcp(@browser, @browser.url)
				}

		end

}
