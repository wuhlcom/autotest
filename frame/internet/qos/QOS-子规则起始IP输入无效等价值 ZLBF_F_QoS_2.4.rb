#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_qos_ip2         = "254"
				@tc_qos_err_ip      = "0"
				@tc_qos_err_ip2     = "255"
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"
				@tc_ip_error        = "��ַ��ֻ��������1-254"
		end

		def process

				operate("1������DUT��������ҳ��") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2����ѡ������IP������ơ�ѡ��������������Ϊ10000kbps") {
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
				}

				operate("3�����һ���������ƹ���") {
						@options_page.add_item
				}

				operate("4����ʼIP��ַ����x.x.x.0") {

				}

				operate("5������IP����x.x.x.254,����Ϊ1000,����ֵΪĬ��ֵ,����") {
						#��ʼIP��ַ��Ч�ȼ���
						puts "������ʼIP��ַΪ#{@tc_qos_err_ip}".encode("GBK")
						puts "������ַΪ#{@tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, @tc_qos_err_ip, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("6����ʼIP��ַ����x.x.x.255,����") {
						#��ʼIP��ַ��Ч�ȼ���
						puts "������ʼIP��ַΪ#{@tc_qos_err_ip2}".encode("GBK")
						puts "������ַΪ#{@tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, @tc_qos_err_ip2, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

		end

		def clearup

				operate("1 ɾ��������������") {
						if @options_page.total_bw?
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						else
								@options_page = RouterPageObject::OptionsPage.new(@browser)
								@options_page.select_traffic_ctl(@browser.url)
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						end
				}
		end

}
