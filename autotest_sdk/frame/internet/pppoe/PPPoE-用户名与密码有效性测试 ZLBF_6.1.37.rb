#
# description:
#  `&\"\'\s �û�������������������ַ���֧��
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.37", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_net_time     = 60
				@tc_wait_time    = 3
				@tc_usr_err      = "�ʺŲ������������ַ��ҳ�����1��32λ"
				@tc_pw_err       = "���벻�����������ַ��ҳ�����1��32λ"
				@tc_usr_null     = "�������ʺ�"
				@tc_netreset_div = "�ɹ�"
		end

		def process

				operate("1����BAS����ץ����") {

				}

				operate("2����½DUT������PPPoE����ҳ�棻") {
						#����ΪPPPOE����
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "����������ʧ��")
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
				}

				operate("3�����û��������������ַ�~!@#$%^&*()_+{}|:<>?�� ������33�������ַ�, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 4 �� ���û���������09, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "0123456789"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 5 �� ���û���������az, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "abcdefghijklmopqrstuvwxyz"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 6 �� ���û���������AZ, �鿴�Ƿ��������뱣�� �� ҳ����ʾ�Ƿ����� �� ץ��ȷ�ϲ����Ƿ��������û������� �� ") {
						tc_pppoe_usr = "ABCDEFGHIJKLMOPQRSTUVWXYZ"
						tc_pppoe_pw  = "PPPOETEST"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}

				operate(" 7 �� �����봦�����ظ�����3 ~7 �� �鿴���Խ�� �� ") {
						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "-=[];\\,./~!@#$%^*()_+{}:|<>?"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_usr)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "0123456789"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end

						tc_pppoe_usr = "pppoe"
						tc_pppoe_pw  = "abcdefghijklmopqrstuvwxyz"
						puts "����PPPOE�ʻ�����PPPOE���룡".to_gbk
						puts "�����û���Ϊ#{tc_pppoe_usr}".encode("GBK")
						puts "�����û���Ϊ#{tc_pppoe_pw}".encode("GBK")
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(tc_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(tc_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						rs = @wan_iframe.div(class_name: @ts_tag_net_reset, text: /#{@tc_netreset_div}/).wait_until_present(@tc_wait_time)
						if rs
								puts "set pppoe mode,Waiting for net reset..."
								sleep @tc_net_time
						end
				}


		end

		def clearup

				operate("�ָ�Ĭ��DHCP����") {
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
						unless rs1.class_name =~/ #{@tc_tag_select_state}/
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
		end

}
