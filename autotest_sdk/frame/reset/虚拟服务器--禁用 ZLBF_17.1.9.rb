#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.9", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_vir_tcpsrv_port = rand_port(50000, 65534)
				@tc_pub_tcp_port    = 30001
				@tc_vir_udpsrv_port = rand_port(40000, 49999)
				@tc_pub_udp_port    = 20001
				@tc_wait_time       = 3
				@tc_wait_dmz_time   = 10
				@tc_reboot_time     = 120
				@tc_relogin_time    = 60
				@tc_net_time        = 50
				@tc_udp_data_time   = 180
		end

		def process

				operate("1����AP������һ��PPPoE���ò��ţ��Զ���ȡIP��ַ�����أ�����������������ܣ�") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "����������ʧ��")

						#����Ϊ����wan
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1=~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						#����Ϊpppoe
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
								@wan_iframe.button(:id, @ts_tag_sbm).click
								# Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
								# 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).visible?
								# }
								# Watir::Wait.while(@tc_net_time, "����������������".to_gbk) {
								# 		@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text).present? #ֱ��������������ʾ������ʧ
								# }
								sleep @tc_net_time
						end

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#�鿴Wan ip��ַ
						@browser.span(:id, @ts_tag_status).click
						sleep @tc_wait_time
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_pppoe_addr = Regexp.last_match(1)
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_pppoe_addr}".to_gbk
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2����AP��������ӷ���FTP(TCP�˿�Ϊ20��21)��HTTP(TCP�˿�Ϊ80)��TELNET(TCP�˿�Ϊ23)��TFTP(UDP�˿�Ϊ69)��,������IP��ַ����ΪPC2��IP��ַ�ȹ���,���棻") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��")

						#ѡ��Ӧ�����á�
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "Virtual Server IP #{@tc_pc_ip}"
						#ѡ���������������ǩ
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						#���������������
						@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						#���һ�����˿�ӳ��
						unless @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						#��ӵڶ������˿�ӳ��
						unless @advance_iframe.text_field(name: @ts_tag_virip2).exists?
								@advance_iframe.button(id: @ts_tag_addvir).click
						end
						@advance_iframe.text_field(name: @ts_tag_virip2).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port2).set(@tc_pub_udp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port2).set(@tc_vir_udpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time
				}

				operate("3��PC1����PC2�����FTP��HTTP��TELNET/TFTP��������") {
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pppoe_addr=~/#{new_net}/
						}

						#���·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_pppoe_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #����Ϊpptp�����ַ
								tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#����udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg
						assert_match(/#{@ts_conn_state}/, udp_msg, "���������������UDP����ʧ��")
				}

				operate("4���ر�AP������������أ�PC1����PC2�����FTP��HTTP��TELNET/TFTP��������") {
						if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
								#�ر��������������
								@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
								@advance_iframe.button(id: @ts_tag_save_btn).click
								sleep @tc_wait_time
						end

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After close portmapping Message from TCP server==============="
						puts tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "�ر������������tcp���ӳɹ�")
						#�Ѿ�������udp�����ڷ���رպ�һ��ʱ��������ͨ�ţ�����һ����ʱ�����޷�ͨ����
						puts "Waiting for UDP...."
						sleep @tc_udp_data_time
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After close portmapping Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "�ر������������UDP���ӳɹ� ")
				}

				operate("5������AP��PC1����PC2�����FTP��HTTP��TELNET/TFTP��������") {
						#�رո߼�����
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#�ҵ�������DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#���ع���Ŀ¼ҳ���DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#���ر�����DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						@browser.span(id: @ts_tag_reboot).click
						reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"
						reboot_confirm.click

						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "����·����ʧ��δ��ת����¼ҳ��!"
						#���µ�¼·����
						rs = login_no_default_ip(@browser)
						assert(rs, "���µ�¼·����ʧ��!")

						#�鿴Wan ip��ַ
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_pppoe_addr = Regexp.last_match(1)
						puts "������WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_pppoe_addr}".to_gbk

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless (@tc_pc_ip2==@tc_pc_ip)
								puts "����·������ ������Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#����udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						rs      = @tc_wan_drb.tcp_client(@tc_pppoe_addr, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================After reboot, Message from TCP server==============="
						print tcp_msg
						refute_match(/#{@ts_conn_state}/, tcp_msg, "�ر������������tcp���ӳɹ�")
						#�ر�
						puts "Waiting for UDP...."
						# sleep @tc_udp_data_time
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_pppoe_addr, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================After reboot,Message from UDP server==============="
						puts udp_msg
						refute_match(/#{@ts_conn_state}/, udp_msg, "�ر������������UDP���ӳɹ�")
				}


		end

		def clearup
				operate("1 ɾ���������������") {
						if @browser.link(id: @ts_tag_options).exists?
								@browser.refresh
								@browser.link(id: @ts_tag_options).click
								sleep @tc_wait_time
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						else
								login_recover(@browser, @ts_default_ip)
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								sleep @tc_wait_time
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

						#ѡ��Ӧ�����á�
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#ѡ���������������ǩ
						virtualsrv       = @advance_iframe.link(id: @ts_tag_virtualsrv)
						virtualsrv_state = virtualsrv.parent.class_name
						virtualsrv.click unless virtualsrv_state==@ts_tag_liclass
						sleep @tc_wait_time
						flag=false
						if @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
								#�ر��������������
								@advance_iframe.button(id: @ts_tag_virtualsrv_sw).click
								flag=true
						end
						if @advance_iframe.text_field(name: @ts_tag_virip1).exists?
								#ɾ���˿�ӳ��
								@advance_iframe.button(id: @ts_tag_delvir).click
								flag=true
						end
						if flag
								#����
								@advance_iframe.button(id: @ts_tag_save_btn).click
								sleep @tc_wait_time
						end
				}

				operate("2 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#����wan���ӷ�ʽΪ��������
						#����Ϊ����wan
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1=~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#����WIRE WANΪdhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}
		end

}
