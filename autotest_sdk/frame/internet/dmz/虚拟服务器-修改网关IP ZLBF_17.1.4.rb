#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				#��̬���ɷ���˿�
				@tc_vir_tcpsrv_port = 41000
				@tc_pub_tcp_port    = 21000
				@tc_wait_time       = 3
				@tc_pptpset_time    = 5
				@tc_net_time        = 50
				@tc_reboot_time     = 180
				@tc_lan_sameseg_ip  = "192.168.100.2"
				@tc_lan_ip_new      = "192.168.123.1"

				@tc_tag_advance_div  = "aui_state_lock aui_state_focus" #focus�ں��ʾѡ���˵�ǰdiv
				@tc_tag_style_zindex = "z-index"
		end

		def process

				operate("1���ָ�DUTĬ�����ã����ý�������ΪPPTP��") {
						#�򿪸߼�����
						option = @browser.link(:id => @ts_tag_options)
						option.click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "�򿪸߼�����ʧ��!")

						#ѡ����������
						network = @advance_iframe.link(:id, @ts_tag_op_network)
						unless network.class_name =~ /#{@ts_tag_select_state}/
								network.click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).wait_until_present(@tc_pptpset_time)

						#����PPTP����
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						puts "Waiting for pptp connection..."
						sleep @tc_net_time #·����������ܻ������������������ӳ�

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

						#��ѯPPTP����״̬
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @tag_status_iframe_src)
						assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
						wan_addr = @status_iframe.b(id: @ts_tag_wan_ip).parent.text
						@ts_tag_ip_regxp=~wan_addr
						@tc_pptp_ip = Regexp.last_match(1)
						puts "PPTP��ȡ��IP��ַΪ��#{@tc_pptp_ip}".to_gbk

						wan_type = @status_iframe.b(id: @ts_tag_wan_type).parent.text
						/(#{@ts_wan_mode_pptp})/=~wan_type
						puts "��ѯ����������Ϊ��#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP��ȡip��ַʧ�ܣ�'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '�������ʹ���'
				}

				operate("2�����һ��������������򣬱������ã���֤�����Ƿ���Ч��") {
						#�򿪸߼�����
						option = @browser.link(:id => @ts_tag_options)
						option.click
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)
						#ѡ��Ӧ�����á�
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end
						#��ѯPC IP��ַ
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip}"
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
						#�������������
						@advance_iframe.text_field(name: @ts_tag_virip1).set(@tc_pc_ip)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						sleep @tc_wait_time

						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						#��ѯ��������Ĭ��·���Ƿ����
						routes = @tc_wan_drb.cmd_route_print()
						puts "WAN Server permanetn route info:"
						p routes[:permanent]
						temp = routes[:permanent].keys.any? { |net|
								new_net = net.sub(/\d+$/, "")
								@tc_pptp_ip=~/#{new_net}/
						}

						#���·�ɲ����ڲ����·��
						unless temp
								dst  = @tc_pptp_ip.sub(/\d+$/, "0")
								mask = "255.255.255.0"
								gw   = @ts_pptp_server_ip #����Ϊpptp�����ַ
								cmd_route_add(dst, mask, gw)
						end

						# ����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						# #TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

				operate("3���޸����ص�ַΪ��Ĭ�ϵ�ַͬ���ε�������ַ����֤����2����ӵĹ����Ƿ���Ч��") {
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

						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)

						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@tc_lan_sameseg_ip)
						@lan_iframe.button(id: @ts_tag_sbm).click
						puts "waiting for router reboot..."
						sleep @tc_reboot_time

						#���µ�¼·����
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_sameseg_ip)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '·�����޷���¼��')
						end

						login_no_default_ip(@browser)
						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2  = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip2}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "�޸�LAN IP Ϊ#{@tc_lan_sameseg_ip}�� ������Virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
						end

						#TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

				operate("4���޸����ص�ַΪ��Ĭ�ϵ�ַ��ͬ���εĵ�ַ�������з���IP��ַ�Ƿ����޸ĳ���Ӧ���ε�IP��ַ�����޸ĳɹ�����֤�����Ƿ���Ч��") {
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@tc_lan_ip_new)
						@lan_iframe.button(id: @ts_tag_sbm).click
						puts "waiting for router reboot..."
						sleep @tc_reboot_time

						#���µ�¼·����
						unless @browser.text_field(:name, @ts_tag_aduser).exist?
								@browser.cookies.clear
								@browser.goto(@tc_lan_ip_new)
								rs = @browser.text_field(:name, @ts_tag_aduser).exist?
								assert(rs, '·�����޷���¼��')
						end

						login_no_default_ip(@browser)
						@browser.span(id: @ts_tag_lan).click
						@browser.iframe(src: @ts_tag_lan_src).wait_until_present(@tc_wait_time)
						@lan_iframe = @browser.iframe(src: @ts_tag_lan_src)

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info     = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip3  = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip3}"
						unless (@tc_pc_ip3==@tc_pc_ip) && (@tc_pc_ip3==@tc_pc_ip2)
								puts "�޸�LAN IP Ϊ#{@tc_lan_ip_new}�� ������Virtual Server IP #{@tc_pc_ip3}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip3, @tc_vir_tcpsrv_port)
						end
						#TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

				operate("5���ڲ���4���޸ĳɹ��Ļ����ϣ��ٽ����ص�ַ�޸ĳ�Ĭ�����ε�IP��ַ����֤�����Ƿ���Ч��") {
						@lan_iframe.text_field(id: @ts_tag_lanip).set(@ts_default_ip)
						@lan_iframe.button(id: @ts_tag_sbm).click
						puts "waiting for router reboot..."
						sleep @tc_reboot_time
						#���µ�¼·����
						rs = @browser.text_field(:name, @ts_tag_aduser).wait_until_present(@tc_wait_time)
						assert rs, '��ת����¼ҳ��ʧ�ܣ�'
						login_no_default_ip(@browser)

						#����·���������PC ��ȡIP��ԭ����ͬ��Ҫ��������tcp����
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip4 = ip_info[:ip][0]
						puts "pc ip addr:#{@tc_pc_ip4}"
						unless (@tc_pc_ip4==@tc_pc_ip) && (@tc_pc_ip4==@tc_pc_ip2) && (@tc_pc_ip4==@tc_pc_ip3)
								puts "�޸�LAN IP Ϊ#{@ts_default_ip}�� ������Virtual Server IP #{@tc_pc_ip4}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip4, @tc_vir_tcpsrv_port)
						end

						#TCP���ӷ������������
						rs2     = @tc_wan_drb.tcp_client(@tc_pptp_ip, @tc_pub_tcp_port)
						tcp_msg = rs2.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
				}

		end

		def clearup
				operate("�ָ�ΪĬ������") {
						login_router_recover(@browser, @ts_default_ip)
				}
		end

}
