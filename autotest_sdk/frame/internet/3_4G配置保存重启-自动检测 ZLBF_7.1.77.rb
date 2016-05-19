#
#description:
# 1 �ϵ��������ű��޷�ʵ��
# 2 �������������ִ�й����޷���SIM�����ֻ�ܲ���һ�ֿ�
# 3 ��Ʒȱ�ݵ������������Զ���ת�ĵ�¼���棬��Ʒ��������������������
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_7.1.29", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time     = 3
				@tc_reboot_time   = 120
				@tc_net_time      = 60
				@tc_dial_time     = 90
				@tc_relogin_time  = 80

				@tc_wan_type           = "3G/4G"
				@tc_tag_wan_span       = "set_network"
				@tc_tag_wan_iframe_src = "netset.asp"

				@tc_tag_wan_mode_link = "tab_3g"
				@tc_tag_wan_mode_span = "dial"

				@tc_tag_wan_mode_span2 = "wire"
				@tc_tag_wan_mode_link2 = "tab_ip"
				@tc_tag_wired_mode     = "ip_type_dhcp"
				@tc_tag_3g_mode        = "3g_auto_type"
				@tc_tag_check_status   = "checked"
				@tc_tag_net_reset_tip  = "aui_state_noTitle aui_state_focus aui_state_lock"

				@tc_tag_status_iframe_src = "setstatus.asp"
				@tc_tag_status_iframe     = "setstatus"
				@tc_tag_select_state      = "selected"
				@tc_tag_btn               = "submit_btn"
		end

		def process
				operate("1 ��������������") {
						@browser.span(:id => @tc_tag_wan_span).click
						@wan_iframe = @browser.iframe
						assert_match /#{@tc_tag_wan_iframe_src}/i, @wan_iframe.src, '����������ʧ�ܣ�'
				}

				operate("2 ����3/4G���ӷ�ʽ") {
						Watir::Wait.until(@tc_wait_time, "�ȴ���������ģʽ����") {
								@wan_iframe.link(:id, @tc_tag_wan_mode_link).visible?
						}
						rs1=@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
						if rs1 !~/#{@tc_tag_select_state}/
								rs2 = @wan_iframe.span(:id => @tc_tag_wan_mode_span).click
								sleep @tc_wait_time
								rs3 = @wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
								assert_match /#{@tc_tag_select_state}/, rs3, 'δѡ��3/4G����'
						end
				}
				operate("3 �����Զ�����") {
						auto_3g = @wan_iframe.radio(:id => @tc_tag_3g_mode)
						rs1     = auto_3g.attribute_value(:checked) #��ѡ�оͻ᷵��"true"�ַ���
						auto_3g.click if !(rs1=="true")
						@wan_iframe.button(:id, @tc_tag_btn).click
						#�ȴ�SIM��ע��ɹ�
						sleep @tc_dial_time
						# net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						# Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
						# 		net_reset_div.visible?
						# }
						# Watir::Wait.while(@tc_net_time, "����������������".to_gbk) {
						# 		net_reset_div.present?
						# }
				}
				operate("4 �鿴WAN״̬") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(:id => @tc_tag_status_iframe).wait_until_present(@tc_wait_time)
						@browser.span(:id => @tc_tag_status_iframe).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_wait_time, "ϵͳ״̬����δ����") {
								@status_iframe = @browser.iframe(:src, @tc_tag_status_iframe_src)
								@status_iframe.present?
						}
						wan_addr     = @status_iframe.b(:id => @tag_wan_ip).parent.text
						wan_type     = @status_iframe.b(:id => @tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @tag_wan_dns).parent.text

						assert_match @ip_regxp, wan_addr, '3G��ȡip��ַʧ�ܣ�'
						assert_match /#{@tc_wan_type}/, wan_type, '�������ʹ���'
						assert_match @ip_regxp, gateway_addr, '3G��ȡ����ip��ַʧ�ܣ�'
						assert_match @ip_regxp, mask, '3G��ȡip��ַ����ʧ�ܣ�'
						assert_match @ip_regxp, dns_addr, '3G��ȡdns ip��ַʧ�ܣ�'

						sim_status = @status_iframe.p(:id => @ts_tag_sim).image(src: @ts_tag_img_normal)
						assert(sim_status.exists?, "SIM��״̬������")
						signal_status = @status_iframe.p(:id => @ts_tag_signal).image(src: @ts_tag_signal_normal)
						signal        = signal_status.alt
						puts "�ź�ǿ��Ϊ��#{signal}".to_gbk
						assert(signal_status.exists?, "SIM���źŲ��ȶ�")
						reg_status = @status_iframe.p(:id => @ts_tag_reg).image(src: @ts_tag_img_normal)
						assert(reg_status.exists?, "SIM��ע�᲻����")
						net_status = @status_iframe.p(:id => @ts_tag_3g_net).image(src: @ts_tag_img_normal)
						assert(net_status.exists?, "SIM�����粻����")
						net_type = @status_iframe.p(:id => @ts_tag_3g_nettype).text
						net_type=~/([34]G)/
						puts "��������Ϊ��#{Regexp.last_match(1)}".to_gbk
						isp_type = @status_iframe.p(:id => @ts_tag_3g_isp).text
						isp_type=~/(\w+\s*\w+)/
						puts "��Ӫ������Ϊ��#{Regexp.last_match(1).strip}".to_gbk
				}

				operate("5 ��֤ҵ��") {
						rs = ping(@ts_web)
						assert(rs, '�޷���������')
				}

				operate("6 ����·����") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						#����·����
						@browser.span(id: @ts_tag_reboot).click
						div_parent = @browser.div(class_name: @ts_tag_net_reset_tip)
						assert div_parent.exists?, "δ��������·������ʾ!"

						reboot_confirm = div_parent.button(class_name: @ts_tag_reboot_confirm)
						assert reboot_confirm.exists?, "δ��ʾ����·����Ҫȷ��!"

						reboot_confirm.click
						#<div class="aui_content" style="padding: 20px 25px;">���������У����Ե�...</div>
						# 	Watir::Wait.until(@tc_wait_time, "����·��������������ʾδ����") {
						# 		div_parent.div(class_name: @ts_tag_rebooting).visible?
						# 	}
						puts "Waitfing for system reboot...."
						sleep(@tc_reboot_time) #����������Ͽ����������������ʹ��sleep���ȴ�����������Watir::Wait���ȴ�
						rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
						assert rs, "��ת����¼ҳ��ʧ��!"
				}

				operate("7 ����·���������µ�¼·����") {
						login_no_default_ip(@browser)
						#�ȴ�SIM��ע��ɹ�
						sleep @tc_dial_time
						@browser.span(:id => @tc_tag_status_iframe).wait_until_present(@tc_wait_time)
						@browser.span(:id => @tc_tag_status_iframe).click
						Watir::Wait.until(@tc_wait_time, "ϵͳ״̬����δ����") {
								@status_iframe = @browser.iframe(:src, @tc_tag_status_iframe_src)
								@status_iframe.present?
						}
						wan_addr     = @status_iframe.b(:id => @tag_wan_ip).parent.text
						wan_type     = @status_iframe.b(:id => @tag_wan_type).parent.text
						mask         = @status_iframe.b(:id => @tag_wan_mask).parent.text
						gateway_addr = @status_iframe.b(:id => @tag_wan_gw).parent.text
						dns_addr     = @status_iframe.b(:id => @tag_wan_dns).parent.text

						assert_match @ip_regxp, wan_addr, '3G��ȡip��ַʧ�ܣ�'
						assert_match /#{@tc_wan_type}/, wan_type, '�������ʹ���'
						assert_match @ip_regxp, gateway_addr, '3G��ȡ����ip��ַʧ�ܣ�'
						assert_match @ip_regxp, mask, '3G��ȡip��ַ����ʧ�ܣ�'
						assert_match @ip_regxp, dns_addr, '3G��ȡdns ip��ַʧ�ܣ�'

						sim_status = @status_iframe.p(:id => @ts_tag_sim).image(src: @ts_tag_img_normal)
						assert(sim_status.exists?, "SIM��״̬������")
						signal_status = @status_iframe.p(:id => @ts_tag_signal).image(src: @ts_tag_signal_normal)
						signal        = signal_status.alt
						puts "�ź�ǿ��Ϊ��#{signal}".to_gbk
						assert(signal_status.exists?, "SIM���źŲ��ȶ�")
						reg_status = @status_iframe.p(:id => @ts_tag_reg).image(src: @ts_tag_img_normal)
						assert(reg_status.exists?, "SIM��ע�᲻����")
						net_status = @status_iframe.p(:id => @ts_tag_3g_net).image(src: @ts_tag_img_normal)
						assert(net_status.exists?, "SIM�����粻����")
						net_type = @status_iframe.p(:id => @ts_tag_3g_nettype).text
						net_type=~/([34]G)/
						puts "��������Ϊ��#{Regexp.last_match(1)}".to_gbk
						isp_type = @status_iframe.p(:id => @ts_tag_3g_isp).text
						isp_type=~/(\w+\s*\w+)/
						puts "��Ӫ������Ϊ��#{Regexp.last_match(1).strip}".to_gbk
				}

				operate("8 ��������֤ҵ��") {
						rs = ping(@ts_web)
						assert(rs, '�������޷���������')
				}

		end

		def clearup

				operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						#login_recover(@browser, @ts_default_ip)
						@browser.span(:id => @tc_tag_wan_span).click
						@wan_iframe = @browser.iframe
						#����wan���ӷ�ʽ
						rs1         = @wan_iframe.link(:id => @tc_tag_wan_mode_link2).class_name
						flag        = false
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span2).click
								flag = true
						end

						#��ѯ�Ƿ�ΪΪdhcpģʽ
						dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wired_mode)
						dhcp_radio_state = dhcp_radio.checked?

						#����WIRE WANΪdhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end
						if flag
								@wan_iframe.button(:id, @tc_tag_btn).click
								puts "sleep #{@tc_net_time} for net reseting..."
								sleep @tc_net_time
						end
				}
		end

}
