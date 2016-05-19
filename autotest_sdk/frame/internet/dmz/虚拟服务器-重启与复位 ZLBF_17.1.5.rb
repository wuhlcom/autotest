#
# description:
# ʹ�þ�̬IP���������Բ�ʹ��PPTP����������
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.5", "level" => "P2", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_wan_drb         = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_vir_tcpsrv_port = 33000
				@tc_vir_udpsrv_port = 34000
				@tc_pub_tcp_port    = 23000
				@tc_pub_udp_port    = 24000
				@tc_wait_time       = 3
				@tc_net_time        = 60
				@tc_reboot_time     = 120
				@tc_relogin_time    = 80
		end

		def process

				operate("1����AP�����þ�̬IP���룬����������������ܣ������һ������,Э��ѡ��TCP/UDP,��ʼ����ֹ�˿�����Ϊ5000������IP��ַ����ΪPC2��ַ�����棻") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "����������ʧ��")

						#��������ģʽ
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						#���þ�̬IP
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time

						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time

						#�ر���һ��ҳ��
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#�鿴Wan ip��ַ
						@browser.span(:id, @ts_tag_status).click
						@browser.iframe(src: @tag_status_iframe_src).wait_until_present(@tc_wait_time)
						@status_iframe= @browser.iframe(src: @tag_status_iframe_src)

						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_static_ip = Regexp.last_match(1)
						puts "WAN״̬��ʾ��ȡ��IP��ַΪ��#{@tc_static_ip}".to_gbk

						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						wan_type =~/(#{@ts_wan_mode_static})/
						puts "WAN״̬��ʾ��������Ϊ��#{Regexp.last_match(1)}".to_gbk

						assert_match /#{@ts_staticIp}/, wan_addr, '��̬ip����ʧ�ܣ�'
						assert_match /#{@ts_wan_mode_static}/, wan_type, '�������ʹ���'

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2���ظ�����1�ֱ���Ӷ˿ں�Ϊ80��8080��137��139��1024��10000��65535����") {
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

						#����������
						ip_info = @tc_wan_drb.netsh_if_ip_show(nicname: "lan", type: "addresses")
						ip_arr  = ip_info[:ip]
						flag    = ip_arr.any? { |ip| ip=~/#{@ts_wan_client_ip}/ }
						assert(flag, "δ����ָ����ip��ַ#{@ts_wan_client_ip}")

						#����tcp_server
						tcp_multi_server(@tc_pc_ip, @tc_vir_tcpsrv_port)
						#����udp server
						udp_server(@tc_pc_ip, @tc_vir_udpsrv_port)

						#�������������
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "���������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "���������������UDP����ʧ��")
				}

				operate("3������DUT���鿴���õĹ����Ƿ������Ч��") {
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

						#��ѯPC IP��ַ
						ip_info    = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_ip2 = ip_info[:ip][0]
						puts "after router reboot��pc ip addr is: #{@tc_pc_ip}"
						puts "after router reboot��Virtual Server IP is:#{@tc_pc_ip}"
						unless @tc_pc_ip2==@tc_pc_ip
								puts "after router reboot��������virtual Server IP #{@tc_pc_ip2}".encode("GBK")
								#����tcp_server
								tcp_multi_server(@tc_pc_ip2, @tc_vir_tcpsrv_port)
								#����udp server
								udp_server(@tc_pc_ip2, @tc_vir_udpsrv_port)
						end

						#�������������
						rs      = @tc_wan_drb.tcp_client(@tc_static_ip, @tc_pub_tcp_port)
						tcp_msg = rs.tcp_message
						puts "=================Message from TCP server==============="
						print tcp_msg
						assert_match(/#{@ts_conn_state}/, tcp_msg, "after router reboot�����������������tcp����ʧ��")
						#udp�ͻ��˿�Ҳ��̬����
						rs2     = @tc_wan_drb.udp_client(@ts_wan_client_ip, rand_port, @tc_static_ip, @tc_pub_udp_port)
						udp_msg = rs2.udp_message
						puts "=================Message from UDP server==============="
						print udp_msg+"\n"
						assert_match(/#{@ts_conn_state}/, udp_msg, "after router reboot�����������������UDP����ʧ��")

						#�򿪸߼�����
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

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
						#���������������
						rs = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_on).exists?
						assert(rs, "������������������ر��ر�")

						virsrv_ip1      = @advance_iframe.text_field(name: @ts_tag_virip1).value
						virsrv_pub_port1= @advance_iframe.text_field(name: @ts_tag_virpub_port1).value
						vrisrv_port1    = @advance_iframe.text_field(name: @ts_tag_virpri_port1).value
						assert_equal(@tc_pc_ip, virsrv_ip1, "����·���������������IP��ַ����")
						assert_equal(@tc_pub_tcp_port.to_s, virsrv_pub_port1, "����·���������˿�#{@tc_pub_tcp_port}����")
						assert_equal(@tc_vir_tcpsrv_port.to_s, vrisrv_port1, "����·���������������ʵ�ʶ˿�#{@tc_vir_tcpsrv_port}����")

						virsrv_ip2      = @advance_iframe.text_field(name: @ts_tag_virip2).value
						virsrv_pub_port2= @advance_iframe.text_field(name: @ts_tag_virpub_port2).value
						vrisrv_port2    = @advance_iframe.text_field(name: @ts_tag_virpri_port2).value
						assert_equal(@tc_pc_ip, virsrv_ip2, "����·���������������IP��ַ����")
						assert_equal(@tc_pub_udp_port.to_s, virsrv_pub_port2, "����·���������˿�#{@tc_pub_udp_port}����")
						assert_equal(@tc_vir_udpsrv_port.to_s, vrisrv_port2, "����·���������������ʵ�ʶ˿�#{@tc_vir_udpsrv_port}����")
				}

				operate("4����λDUT���鿴�����Ƿ���ȫ��գ�") {
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

						#���µ�¼·����
						rs_relogin = login_no_default_ip(@browser)
						assert(rs_relogin, "���µ�¼·����ʧ��!")

						#�򿪸߼�����
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

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
						#���������������
						rs = @advance_iframe.button(id: @ts_tag_virtualsrv_sw, class_name: @ts_tag_virsw_off).exists?
						assert(rs, "�ָ��������ú��������������δ�ر�")

						rs2 = @advance_iframe.text_field(name: @ts_tag_virip1).exists?
						refute(rs2, "�ָ��������ú��������������1δɾ��")

						rs3 = @advance_iframe.text_field(name: @ts_tag_virip2).exists?
						refute(rs3, "�ָ��������ú��������������2δɾ��")
				}


		end

		def clearup
				# operate("�ָ�ΪĬ������") {
				# 		login_router_recover(@browser, @ts_default_ip)
				# }

				operate("1 �ָ�Ĭ��DHCP����") {
						if @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#����wan���ӷ�ʽΪ��������
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#����WIRE WANΪDHCPģʽ
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate("2 ɾ���������������") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe  = @browser.iframe(src: @ts_tag_advance_src)

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
		end

}
