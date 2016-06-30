#
# description:
#   ��Ʒ������,������LAN��ͬ��IP��ַ��ʾ"·����������IP��ַ��ʽ����"��Ӧ����ʾ"����������·����������IP��ͬ��IP"
#   �������������ͬ���ε�IP�ܱ���ɹ�
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.3", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time= 3
				@tc_dmz_ip1  = "0.0.0.0"
				@tc_dmz_ip2  = "255.255.255.255"
				@tc_dmz_ip3  = "0.192.168.254"

				@tc_dmz_ip4 = "224.0.0.2"
				@tc_dmz_ip5 = "240.0.0.2"

				@tc_dmz_ip6 = "256"
				@tc_dmz_ip7 = "-11"
				@tc_dmz_ip8 = "192.168.256.254"
				@tc_dmz_ip9 = "192.-11.25.254"

				@tc_dmz_ip10 = "192.168.100.255"
				@tc_dmz_ip11 = "192.168.100.0"

				@tc_dmz_ip12 = "10.10.10.3"

				@tc_dmz_ip13 = "127.0.0.2"

				@tc_ipaddr_error = "IP��ַ��ʽ����"
				@tc_ipaddr_error1 = "��ַ��ip����"

		end

		def process

				operate("1���ڡ�IP��ַ������ȫ0��ȫ1����0��ͷ��ַ��0��β��ַ���磺0.0.0.0��255.255.255.255��0.0.0.1��192.0.0.0�Ƿ��������룻") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #�õ�dmz����״̬
						@options_page.click_dmz_switch if dmz_switch_status == "off"
						puts "����DMZ��������ַΪ#{@tc_dmz_ip1}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip1)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip2}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip2)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip3}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip3)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")
				}

				operate("2���ڡ�IP��ַ������D���ַ��E���ַ���鲥��ַ���磺224.1.1.1��240.1.1.1��255.1.1.1���Ƿ��������룻") {
						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip4}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip4)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip5}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip5)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "��ʾ���ݴ���")
				}

				operate("3���ڡ�IP��ַ���������255��С��0��С�������֣��磺256��-11���Ƿ��������룻") {
						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip6}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip6)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip7}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip7)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip8}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip8)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip9}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip9)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")
				}

				operate("4���ڡ�IP��ַ������㲥��ַ���磺192.168.2.255,10.255.255.255���Ƿ��������룻") {
						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip10}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip10)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip11}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip11)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

				}

				operate("5��������LAN��IPͬһ����ַ���磺192.168.100.1���Ƿ��������룻") {
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_gw = ip_info[:gateway][0]
						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_pc_gw}".encode("GBK")
						@options_page.dmz_input(@tc_pc_gw)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")
				}

				operate("6��������DUT WAN����ͬ���εĵ�ַ���Ƿ��������룻") {
						# ����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip12}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip12)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "��ʾ���ݴ���")
				}

				operate("7������ػ���ַ���磺127.0.0.1���Ƿ��������룻") {
						#����dmz ������ip
						puts "����DMZ��������ַΪ#{@tc_dmz_ip13}".encode("GBK")
						@options_page.dmz_input(@tc_dmz_ip13)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error1, error_tip, "��ʾ���ݴ���")
				}

				operate("8����IP��ַ����A~Z,a~z,~!@#$%^��33�������ַ������ģ��ո�Ϊ�յȣ��Ƿ��������룻") {
						#����dmz ������ip
						tc_dmz_ip1="abc"
						tc_dmz_ip2=" "
						tc_dmz_ip3="#*"
						puts "����DMZ��������ַΪ#{tc_dmz_ip1}".encode("GBK")
						@options_page.dmz_input(tc_dmz_ip1)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						puts "����DMZ��������ַΪ�ո�".encode("GBK")
						@options_page.dmz_input(tc_dmz_ip2)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")

						puts "����DMZ��������ַΪ#{tc_dmz_ip3}".encode("GBK")
						@options_page.dmz_input(tc_dmz_ip3)
						@options_page.save_dmz
						error_tip = @options_page.dmz_err_msg
						assert(error_tip, "δ��ʾ�������")
						puts("ERROR TIP:#{error_tip}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip, "��ʾ���ݴ���")
				}


		end

		def clearup
				operate("ȡ��DMZ") {
						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_options_page(@browser.url)
						@options_page.open_apply_page
						@options_page.open_dmz_page
						dmz_switch_status = @options_page.dmz_switch_status #�õ�dmz����״̬
						 if dmz_switch_status == "on"
								 @options_page.click_dmz_switch
								 @options_page.save_dmz
								 sleep @tc_wait_time
						 end
				}
		end

}
