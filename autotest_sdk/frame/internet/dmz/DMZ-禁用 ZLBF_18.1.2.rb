#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.2", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_dmz_tcpsrv_port = rand_port(50000, 65534)
				@tc_dmz_udpsrv_port = rand_port(40000, 49999)
				@tc_wait_time       = 3
				@tc_wait_dmz_time   = 10
				@tc_net_time        = 30
				@tc_reboot_time     = 180
				#dmz�رպ��Ѿ����͹�udp���ݵĶ˿���Ҫ�ȴ������Ӳ���Ч
				#�������˿�������Ч
				@tc_udp_data_time   = 180
		end

		def process

				operate("1����AP������һ��PPTP���ò��ţ��Զ���ȡIP��ַ�����أ�����DMZ���ܣ�����DMZĿ��IPΪ�¹�PC2��IP��ַ��") {
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe=@browser.iframe(src: @tag_status_iframe_src)
						lan_ip        = @status_iframe.b(id: @ts_tag_lan_ip).parent.text
						#���·��������Ĭ��lanip�Ȼָ�ΪĬ��ip
						unless lan_ip =~/#{@ts_default_ip}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
								assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

								#ѡ��ϵͳ���á�
								sysset      = @advance_iframe.link(id: @ts_tag_op_system)
								sysset_name = sysset.class_name
								unless sysset_name == @ts_tag_select_state
										sysset.click
										sleep @tc_wait_time
								end

								#ѡ�񡰻ָ��������á���ǩ
								system_reset       = @advance_iframe.link(id: @ts_tag_recover)
								system_reset_state = system_reset.parent.class_name
								system_reset.click unless system_reset_state==@ts_tag_liclass
								sleep @tc_wait_time
								#������ָ��������á���ť
								@advance_iframe.button(id: @ts_tag_reset_factory).click
								sleep @tc_wait_time
								reset_confirm_tip = @advance_iframe.div(class_name: @ts_tag_reset, text: @ts_tag_reset_text)
								assert reset_confirm_tip.visible?, "δ�����ָ�������ʾ!"
								#ȷ�ϻָ�����ֵ
								reset_confirm = @advance_iframe.button(class_name: @ts_tag_reboot_confirm)
								reset_confirm.click
								puts "Waitfing for system reboot...."
								sleep @tc_reboot_time #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
								rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
								assert rs, "�ָ��������ú�δ��ת��·������¼ҳ��!"
								login_no_default_ip(@browser) #���µ�¼
						end
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��")

						network_class = @advance_iframe.link(:id, @ts_tag_op_network).class_name
						unless network_class =~ /#{@ts_tag_select_state}/
								@advance_iframe.link(:id, @ts_tag_op_network).click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						sleep @tc_wait_time

						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time #·����������ܻ������������������ӳ�
				}

				operate("2����PC2�Ͻ���FTP��������tftp��������") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��")
						sleep @tc_wait_time
						#ѡ��Ӧ�����á�
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@pc_ip_addr = ip_info[:ip][0]
						puts "DMZ Server IP #{@pc_ip_addr}"
						#ѡ��DMZ���á���ǩ
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#��dmz����
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
						#����dmz ������ip
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@pc_ip_addr)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
				}

				operate("3����PC1�Ͽ���TFTP�� FTP�ͻ��˷���AP��WAN��IP��ַ,��������Ӧ��ҵ�����ػ����ϴ����ֱ���PC2�����ϣ�Server��ץ���۲죻") {
						#�鿴Wan ip��ַ
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)
						wan_addr      = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_ppptp_addr = Regexp.last_match(1)
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_ppptp_addr}".to_gbk

						#lan����wan
						http_get = HtmlTag::TestHttpClient.new(@ts_wan_pppoe_httpip).get
						puts "=================�ͻ��˻�ȡ��Http Server Message=================".encode("GBK")
						print http_get+"\n"
						assert_match(/#{@ts_conn_state}/, http_get, "����dmz�󣬿ͻ���1���ӵ�WAN��http����ʧ��")

						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  =ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						routes = @tc_wan_drb.cmd_route_print()
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_ppptp_addr=~/#{new_net}/
						}

						#���·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_ppptp_addr.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip
								@tc_wan_drb.cmd_route_add(dst, mask, gw)
						end

						#����tcp_server
						@tc_tcp_srvthr = tcp_multi_server(@pc_ip_addr, @tc_dmz_tcpsrv_port)
						#����udp server
						@tc_udp_srvthr = udp_server(@pc_ip_addr, @tc_dmz_udpsrv_port)
				}

				operate("4����PC2�Ϸ���PC1��WEB�����Ƿ�ɹ���") {
						#wan����lan dmz
						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						puts tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "����dmz��tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port, "PPTP")
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						puts udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "����dmz��UDP����ʧ��")
				}

				operate("5������DMZ���ظ�����3��4��") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep(@tc_wait_dmz_time)
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

						#ѡ��Ӧ�����á�
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#ѡ��DMZ���á���ǩ
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#�ر�dmz����
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time

						rs      = @tc_wan_drb.tcp_client(@tc_ppptp_addr, @tc_dmz_tcpsrv_port)
						tcp_msg = rs.tcp_message
						puts "=================After closed DMZ,Message from TCP server==============="
						puts "no message: #{tcp_msg}"
						refute_match(/#{@ts_conn_state}/, tcp_msg, "�ر�dmz��tcp��������")

						#udp�ͻ��˿�Ҳ��̬����rand_port
						sleep @tc_udp_data_time
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_ppptp_addr, @tc_dmz_udpsrv_port)
						udp_msg = rs2.udp_message
						puts "=================After closed DMZ,Message from UDP server==============="
						puts "no message: #{udp_msg}"
						refute_match(/#{@ts_conn_state}/, udp_msg, "�ر�dmz��UDP��������")
				}

				operate("6��������������DMZ 3�����ϣ�AP�����Ƿ�������") {
						2.times.each do |i|
								puts "Repeat open and close DMZ #{i} time"
								#��dmz����
								@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
								@advance_iframe.text_field(id: @ts_tag_dmzip).set(@pc_ip_addr)
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
								#�ر�DMZ
								@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
						rs=ping(@ts_web)
						assert(rs, "·�����޷���������")
				}


		end

		def clearup

				operate("1 �ر�DMZ�������ϵķ���") {
						@tc_tcp_srvthr.kill if !@tc_tcp_srvthr.nil? && @tc_tcp_srvthr.alive?
						@tc_udp_srvthr.kill if !@tc_udp_srvthr.nil? && @tc_udp_srvthr.alive?
				}
				operate("2 ȡ��DMZ") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

						#ѡ��Ӧ�����á�
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#ѡ��DMZ���á���ǩ
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time

						if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								#�ر�dmz����
								@advance_iframe.button(id: @ts_tag_dmzsw).click
								#�ύ
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
				}

				operate("3 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
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
