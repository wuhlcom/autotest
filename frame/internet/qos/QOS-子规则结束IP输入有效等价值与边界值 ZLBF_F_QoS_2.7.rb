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
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ10000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
						@options_page.add_item
				}

				operate("2����ʼIP��ַ����x.x.x.1") {

				}

				operate("3��������ƵĶԹ���1����ʼ������ַ�߽���в���") {
						#�߽�ֵ����
						#��ʼIP��ַ�±߽�
						tc_qos_ip  = "1"
						tc_qos_ip2 = "254"
						tc_qos_ip3 = "100"
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")

						#��ʼIP��ַ�ϱ߽�
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")

						# ����IP��ַ�±߽�
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip3}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip3, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")
				}

		end

		def clearup

				operate("1 ɾ��������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #����
				}
		end

}
