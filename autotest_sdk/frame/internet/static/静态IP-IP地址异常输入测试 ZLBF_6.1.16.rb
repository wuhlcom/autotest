#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.16", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_noip_tip     = "������ IP ��ַ"
				@tc_ip_error_tip = "IP��ַ��ʽ����"
				@tc_static_time  = 50
				@tc_wait_time    = 2
				@tc_tip_time     = 10
		end

		def process

				operate("1��ѡ��̬IP���ŷ�ʽ��") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '����������ʧ�ܣ�')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time
				}

				operate("2����IP��ַ����0��ͷ��ַ����0��β��ַ���磺0.0.0.0��10.0.0.0�Ƿ��������룻") {
						#����յ�ַ
						tc_staticIp =""
						puts "����IP��ַΪ��".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_noip_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						#0��ͷ
						tc_staticIp="0.10.10.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						#���Ա߽磬1��ͷ
						tc_staticIp     = "1.10.10.2"
						tc_staticGateway= "1.10.10.1"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_tip_time, "δ��������������ʾ!".encode("GBK")) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						}
						sleep @tc_static_time

						#���223
						tc_staticIp     = "223.10.10.2"
						tc_staticGateway= "223.10.10.1"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_tip_time, "δ��������������ʾ!".encode("GBK")) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						}
						sleep @tc_static_time

						#�������ֵ������224
						tc_staticIp = "224.10.10.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						#ĩβ����0
						tc_staticIp="10.10.10.0"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						#���� 255
						tc_staticIp="10.10.10.255"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						#���� 254
						tc_staticIp="10.10.10.254"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_tip_time, "δ��������������ʾ!".encode("GBK")) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						}
						sleep @tc_static_time
				}

				operate("3��IP��ַ�����鲥��ַ����239.1.1.1���Ƿ��������룻") {
						#�ڶ������Ѿ�����
				}

				operate("4��IP��ַ����E���ַ����240.1.1.1���Ƿ��������룻") {
						tc_staticIp = "240.1.1.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")
				}

				operate("5��IP��ַ���뻷�ص�ַ����127��ͷ�ĵ�ַ����127.0.0.1���Ƿ��������룻") {
						tc_staticIp = "127.0.0.2"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")
				}

				operate("6��IP��ַ��������ʽ��ַ����192.168.10��a.a.a.a�ȣ�") {
						tc_staticIp="10.10.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.10.10.a"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.10.-1.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						tc_staticIp="10.@.10.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")

						tc_staticIp="*.10.10.10"
						puts "����IP��ַΪ:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						3.times {
								break if @wan_iframe.text_field(:id, @ts_tag_staticIp).value != ""
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "δ����������ʾ!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_error_tip, error_tip.text, "������ʾ���ݲ���ȷ!")
				}


		end

		def clearup
				operate("1 �ָ�Ĭ��DHCP����") {
						if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
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
						unless rs1.class_name =~/#{@ts_tag_select_state}/
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
								sleep @tc_static_time
						end
				}
		end

}
