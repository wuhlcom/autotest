#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.4", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_wait_time          = 3
				@tc_status_wait        = 5
				@tc_net_time           = 50
				@tc_diagnose_time      = 120
				@tc_err_pppoe_usr = 'pppoe@err'
				@tc_err_pppoe_pw  = 'PPPOEPWERR'

		end

		def process

				operate("1�������������ò��ŷ�ʽΪPPPOE,���������ʻ�������") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '����������ʧ�ܣ�')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end

						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "���ô����PPPOE�ʻ���:#{@tc_err_pppoe_usr}��PPPOE���룺#{@tc_err_pppoe_pw}��".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@tc_err_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@tc_err_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_net_time

						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						#��·����״̬ҳ��
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_wait #�ȴ�ҳ����ʾ
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
						Watir::Wait.until(@tc_status_wait, "״̬ҳ�����ʧ��") {
								@status_iframe.b(:id => @ts_tag_wan_type).present?
						}
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						refute_match @ts_tag_ip_regxp, wan_addr, 'PPPOEӦ�޷���ȡ����ַ��'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
				}

				operate("2�����������˺����룬ʹ���Ų��ɹ������ϵͳ��ϣ��鿴��Ͻ����") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						#open diagnose
						@browser.link(id: @ts_tag_diagnose).click()
						sleep @tc_wait_time
						#�õ�@browser�����¸������ڶ���ľ������
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "δ����ϴ���")
						#ͨ��������л���ͬ��windows���ڣ������л�����ϴ���
						@browser.driver.switch_to.window(@tc_handles[1])
						sleep @tc_status_wait
						Watir::Wait.while(@tc_diagnose_time, "��Ϲ��̳���") {
								puts "#{@ts_tag_diag_detecting}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait.until(@tc_wait_time, "��Ͻ������") {
								puts "#{@ts_tag_diag_fini_fail}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_fini_fail).present?
						}

						tc_diag_3gdial =@browser.span(id: @ts_tag_diag_3gdial, text: @tc_tag_diag_3gdial_text).exists?
						assert(tc_diag_3gdial, "δ��ʾ3G״̬")
						tc_diag_3gdial_status = @browser.span(id: @ts_tag_diag_3gdial_status).text
						puts "3G Dial status:#{tc_diag_3gdial_status}".to_gbk
						assert_equal(tc_diag_3gdial_status, @ts_tag_diag_fail, "3G״̬Ӧ����ʾΪ'�쳣'")

						tc_diag_wan =@browser.span(id: @ts_tag_diag_wan, text: @ts_tag_diag_wan_text).exists?
						assert(tc_diag_wan, "δ��ʾWAN����״̬")
						tc_diag_wan_status = @browser.span(id: @ts_tag_diag_wan_status).text
						puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
						assert_equal(tc_diag_wan_status, @ts_tag_diag_success, "��ʾWAN����״̬�쳣")

						tc_diag_internet =@browser.span(id: @ts_tag_diag_internet, text: @ts_tag_diag_internet_text).exists?
						assert(tc_diag_internet, "δ��ʾWAN����״̬")
						tc_diag_internet_status = @browser.span(id: @ts_tag_diag_internet_status).text
						puts "Internet status:#{tc_diag_internet_status}".to_gbk
						assert_equal(tc_diag_internet_status, @ts_tag_diag_fail, "��ʾWAN����״̬Ӧ��Ϊ'�쳣'")
						tc_diag_internet_err = @browser.div(text: @ts_tag_diag_internet_err)
						assert(tc_diag_internet_err.exists?, "�����쳣��ʾ���ݴ���!")

						tc_diag_hardware = @browser.span(id: @ts_tag_diag_hardware, text: @ts_tag_diag_hardware_text).exists?
						assert(tc_diag_hardware, "δ��ʾ·��������״̬")
						tc_diag_hardware_status = @browser.span(id: @ts_tag_diag_hardware_status).text
						puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
						assert_equal(tc_diag_hardware_status, @ts_tag_diag_success, "��ʾ·��������״̬�쳣")

						tc_diag_netspeed = @browser.span(id: @ts_tag_diag_netspeed, text: @ts_tag_diag_netspeed_text).exists?
						assert(tc_diag_netspeed, "δ��ʾ��������")
						tc_diag_netspeed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
						puts "NetSpeed status:#{tc_diag_netspeed_status}".to_gbk
						assert_equal(tc_diag_netspeed_status, @ts_tag_diag_fail, "��ʾ���������쳣")
						tc_diag_netspeed_err1 = @browser.p(text: @ts_tag_diag_netspeed_err1)
						tc_diag_netspeed_err2 = @browser.p(text: @ts_tag_diag_netspeed_err2)
						tc_diag_netspeed_err3 = @browser.p(text: @ts_tag_diag_netspeed_err3)
						assert(tc_diag_netspeed_err1.exists?, "�����쳣������ʾ����!")
						assert(tc_diag_netspeed_err2.exists?, "�����쳣������ʾ����!")
						assert(tc_diag_netspeed_err3.exists?, "�����쳣�˿���ʾ����!")

						tc_diag_cpu=@browser.span(id: @ts_tag_diag_cpu, text: @ts_tag_diag_cpu_text).exists?
						assert(tc_diag_cpu, "δ��ʾ������״̬")
						tc_diag_cpu_status = @browser.div(xpath: @ts_tag_diag_cpu_xpath).text
						puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
						assert_match(@ts_tag_cpu_type_reg, tc_diag_cpu_status, "��ʾ�����������쳣")
						assert_match(@ts_tag_cpu_name_reg, tc_diag_cpu_status, "��ʾ�����������쳣")
						assert_match(@ts_tag_cpu_load_reg, tc_diag_cpu_status, "��ʾ�����������쳣")

						tc_diag_mem = @browser.span(id: @ts_tag_diag_mem, text: @ts_tag_diag_mem_text).exists?
						assert(tc_diag_mem, "δ��ʾ�ڴ�״̬")
						tc_diag_mem_status = @browser.div(xpath: @ts_tag_diag_mem_xpath).text
						puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
						assert_match(@ts_tag_mem_total_reg, tc_diag_mem_status, "��ʾ�ڴ��ܴ�С�����쳣")
						assert_match(@ts_tag_mem_useful_reg, tc_diag_mem_status, "��ʾ�����ڴ��쳣")
						assert_match(@ts_tag_mem_cache_reg, tc_diag_mem_status, "��ʾ����ռ��쳣")
				}

				operate("3�������������ò��ŷ�ʽΪPPPOE,������ȷ���ʻ�������") {
						#ͨ��������л���ͬ��windows����
						@browser.driver.switch_to.window(@tc_handles[0])
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '����������ʧ�ܣ�')
						puts "������ȷ��PPPOE�ʻ���:#{@ts_pppoe_usr}��PPPOE����:#{@ts_pppoe_pw}��".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						net_reset_div = @wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						Watir::Wait.until(@tc_wait_time, "�ȴ�����������ʾ����".to_gbk) {
								net_reset_div.visible?
						}
						Watir::Wait.while(@tc_net_time, "����������������".to_gbk) {
								net_reset_div.present?
						}
						#��·����״̬ҳ��
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_wait #�ȴ�ҳ����ʾ
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '��WAN״̬ʧ�ܣ�')
						sleep @tc_status_wait
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ts_tag_ip_regxp, wan_addr, 'PPPOEδ��ȡ����ַ��'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '�������ʹ���'
				}

				operate("4��������ȷ���˺����룬ʹ���ųɹ������ϵͳ��ϣ��鿴��Ͻ����") {
						#ͨ��������л���ͬ��windows����
						@browser.driver.switch_to.window(@tc_handles[1])
						@browser.refresh #ˢ��ҳ���������
						sleep @tc_status_wait
						Watir::Wait.while(@tc_diagnose_time, "��Ϲ��̳���") {
								puts "#{@ts_tag_diag_detecting}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait.until(@tc_wait_time, "��Ͻ������") {
								puts "#{@ts_tag_diag_fini_success}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_fini_success).present?
						}
						tc_diag_3gdial =@browser.span(id: @ts_tag_diag_3gdial, text: @tc_tag_diag_3gdial_text).exists?
						assert(tc_diag_3gdial, "δ��ʾ3G״̬")
						tc_diag_3gdial_status = @browser.span(id: @ts_tag_diag_3gdial_status).text
						puts "3G Dial status:#{tc_diag_3gdial_status}".to_gbk
						assert_equal(tc_diag_3gdial_status, @ts_tag_diag_fail, "3G״̬Ӧ����ʾΪ'�쳣'")

						tc_diag_wan =@browser.span(id: @ts_tag_diag_wan, text: @ts_tag_diag_wan_text).exists?
						assert(tc_diag_wan, "δ��ʾWAN����״̬")
						tc_diag_wan_status = @browser.span(id: @ts_tag_diag_wan_status).text
						puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
						assert_equal(tc_diag_wan_status, @ts_tag_diag_success, "��ʾWAN����״̬�쳣")

						tc_diag_internet =@browser.span(id: @ts_tag_diag_internet, text: @ts_tag_diag_internet_text).exists?
						assert(tc_diag_internet, "δ��ʾWAN����״̬")
						tc_diag_internet_status = @browser.span(id: @ts_tag_diag_internet_status).text
						puts "Internet status:#{tc_diag_internet_status}".to_gbk
						assert_equal(tc_diag_internet_status, @ts_tag_diag_success, "��ʾWAN����״̬�쳣")

						tc_diag_hardware = @browser.span(id: @ts_tag_diag_hardware, text: @ts_tag_diag_hardware_text).exists?
						assert(tc_diag_hardware, "δ��ʾ·��������״̬")
						tc_diag_hardware_status = @browser.span(id: @ts_tag_diag_hardware_status).text
						puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
						assert_equal(tc_diag_hardware_status, @ts_tag_diag_success, "��ʾ·��������״̬�쳣")

						tc_diag_netspeed = @browser.span(id: @ts_tag_diag_netspeed, text: @ts_tag_diag_netspeed_text).exists?
						assert(tc_diag_netspeed, "δ��ʾ��������")
						tc_diag_netspeed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
						puts "Hardware status:#{tc_diag_netspeed_status}".to_gbk
						assert_equal(tc_diag_netspeed_status, @ts_tag_diag_success, "��ʾ���������쳣")

						tc_diag_cpu=@browser.span(id: @ts_tag_diag_cpu, text: @ts_tag_diag_cpu_text).exists?
						assert(tc_diag_cpu, "δ��ʾ������״̬")
						tc_diag_cpu_status = @browser.div(xpath: @ts_tag_diag_cpu_xpath).text
						puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
						assert_match(@ts_tag_cpu_type_reg, tc_diag_cpu_status, "��ʾ�����������쳣")
						assert_match(@ts_tag_cpu_name_reg, tc_diag_cpu_status, "��ʾ�����������쳣")
						assert_match(@ts_tag_cpu_load_reg, tc_diag_cpu_status, "��ʾ�����������쳣")

						tc_diag_mem = @browser.span(id: @ts_tag_diag_mem, text: @ts_tag_diag_mem_text).exists?
						assert(tc_diag_mem, "δ��ʾ�ڴ�״̬")
						tc_diag_mem_status = @browser.div(xpath: @ts_tag_diag_mem_xpath).text
						puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
						assert_match(@ts_tag_mem_total_reg, tc_diag_mem_status, "��ʾ�ڴ��ܴ�С�����쳣")
						assert_match(@ts_tag_mem_useful_reg, tc_diag_mem_status, "��ʾ�����ڴ��쳣")
						assert_match(@ts_tag_mem_cache_reg, tc_diag_mem_status, "��ʾ����ռ��쳣")
				}

				operate("5��������������Internet�����ϵͳ��ϣ��鿴��Ͻ����") {

				}


		end

		def clearup

				operate("1 �ָ�ΪĬ�ϵĽ��뷽ʽ��DHCP����") {
						unless @tc_handles.nil?
								@browser.driver.switch_to.window(@tc_handles[0])
						end

						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#����wan���ӷ�ʽΪ��������
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@ts_tag_select_state}/
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
