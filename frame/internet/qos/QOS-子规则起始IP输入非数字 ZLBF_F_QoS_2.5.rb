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
        @tc_ip_error2       = "ֻ������������"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ10000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
						@options_page.add_item
				}

				operate("2�����������쳣ֵ������������ĸ�����֣������ַ���С�������գ�0��ֵ��������棬�Ƿ��ܱ���ɹ�") {
						#�������
						tc_qos_ip      = "254"
						tc_qos_err_ip2 = "��ַ" #����
						tc_qos_err_ip3 = "@" #����
						tc_qos_err_ip4 = "c" #��ĸ
						puts "�������IP��ַΪ:#{tc_qos_ip}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_ip


						puts "������ʼIP��ַΪ��#{tc_qos_err_ip2}".encode("GBK") #����
						@options_page.bw_ip_min0=tc_qos_err_ip2
            @options_page.save_traffic #����
            sleep @tc_wait_time
            error_tip = @options_page.error_msg
            puts "ERROR TIP #{error_tip}".encode("GBK")
            assert_equal(@tc_ip_error2, error_tip, "��ʾ��Ϣ���ݴ���!")

						puts "������ʼIP��ַΪ��#{tc_qos_err_ip3}".encode("GBK") #����
						@options_page.bw_ip_min0=tc_qos_err_ip3
            @options_page.save_traffic #����
            sleep @tc_wait_time
            error_tip = @options_page.error_msg
            puts "ERROR TIP #{error_tip}".encode("GBK")
            assert_equal(@tc_ip_error2, error_tip, "��ʾ��Ϣ���ݴ���!")

						puts "������ʼIP��ַΪ��#{tc_qos_err_ip4}".encode("GBK") #��ĸ
						@options_page.bw_ip_min0=tc_qos_err_ip4
            @options_page.save_traffic #����
            sleep @tc_wait_time
            error_tip = @options_page.error_msg
            puts "ERROR TIP #{error_tip}".encode("GBK")
            assert_equal(@tc_ip_error2, error_tip, "��ʾ��Ϣ���ݴ���!")
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
