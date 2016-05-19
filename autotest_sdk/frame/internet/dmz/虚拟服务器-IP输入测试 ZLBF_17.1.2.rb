#
# description:
# bug:�����������������LAN���IP��ַ
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_17.1.2", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_pub_tcp_port    = 5869
				@tc_vir_tcpsrv_port = 80
				@tc_ip_error_tip    = "IP��ַ��ʽ����"
		end

		def process

				operate("1���ڡ�IP��ַ������ȫ0��ȫ1����0��ͷ��ַ��0��β��ַ���磺0.0.0.0��255.255.255.255��0.0.0.1��192.0.0.0�Ƿ��������룻") {
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
						virtualsrv_ip_addr1 = "0.168.100.100"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr1}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr1)
						@advance_iframe.text_field(name: @ts_tag_virpub_port1).set(@tc_pub_tcp_port)
						@advance_iframe.text_field(name: @ts_tag_virpri_port1).set(@tc_vir_tcpsrv_port)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")
						sleep @tc_wait_time

						virtualsrv_ip_addr3 = "192.168.100.0"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr3}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr3)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")

				}

				operate("2���ڡ�IP��ַ������D���ַ��E���ַ���鲥��ַ���磺224.1.1.1��240.1.1.1��255.1.1.1���Ƿ��������룻") {
						virtualsrv_ip_addr5 = "224.168.100.10"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr5}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr5)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")
				}

				operate("3���ڡ�IP��ַ���������255��С��0��С�������֣��磺256��-11���Ƿ��������룻") {
						virtualsrv_ip_addr7 = "100"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr7}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr7)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")

						virtualsrv_ip_addr4 = "192.168.-100.100"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")
				}

				operate("4���ڡ�IP��ַ������㲥��ַ���磺192.168.2.255,10.255.255.255���Ƿ��������룻") {
						virtualsrv_ip_addr4 = "192.168.100.255"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")
				}

				operate("5��������DUT WAN�ڵ�IP��ַ��ַ���Ƿ��������룻") {
#padding
				}

				operate("6������ػ���ַ���磺127.0.0.1���Ƿ��������룻") {
						virtualsrv_ip_addr4 = "127.0.0.1"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr4}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr4)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")
				}

				operate("7����IP��ַ����A~Z,a~z,~!@#$%^��33�������ַ������ģ��ո�Ϊ�յȣ��Ƿ��������룻") {
						virtualsrv_ip_addr = "����"
						p "�������������IP��ַΪ:#{virtualsrv_ip_addr}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(virtualsrv_ip_addr)
						@advance_iframe.button(id: @ts_tag_save_btn).click
				}

				operate("8��������LAN��IPͬһ����ַ���磺192.168.100.1���Ƿ��������룻") {
						#����Ӧ�ò�����������LAN��ͬ�ĵ�ַ
						ip_info = ipconfig
						srv_ip  = ip_info[@ts_nicname][:gateway][0]
						p "�������������IP��ַΪ:#{srv_ip}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_virip1).set(srv_ip)
						@advance_iframe.button(id: @ts_tag_save_btn).click
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "��ʾ�����ַ����")
						error_info=error_tip.text
						assert_equal(@tc_ip_error_tip, error_info, "��ʾ��Ϣ����")
				}


		end

		def clearup
				operate("1 ɾ���������������") {
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
