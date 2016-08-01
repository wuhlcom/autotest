#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time        = 2
				#kbps
				@tc_bandwidth_total  = "1000"
				@tc_bandwidth_limit1 = "10.1"
				@tc_bandwidth_limit2 = "0.56"
				@tc_bandwidth_limit3 = "@100"
				@tc_bandwidth_limit4 = "1&00"
				@tc_bandwidth_limit5 = "10-1"
				@tc_bandwidth_limit6 = "5\6"
				@tc_bandwidth_limit7 = "10=0"
				@tc_bandwidth_limit8 = "10#0"
				@tc_bandwidth_limit9 = ""
				@tc_qos_ip1          = "100"
				@tc_qos_ip2          = "200"
				@tc_qos_err_msg1     = "ֻ������������"
				@tc_qos_err_msg2     = "�����������������"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ1000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
						@options_page.add_item
				}

				operate("2����ʼIP��ַ����100��������ַ����200") {
				}

				operate("3������������ֱ�����Ϊ10.1��0.56��@100��1&00") {
						p "��������������Ϊ:#{@tc_bandwidth_limit1}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit1)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")

						p "��������������Ϊ:#{@tc_bandwidth_limit2}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit2)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")

						p "��������������Ϊ:#{@tc_bandwidth_limit3}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit3)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")

						p "��������������Ϊ:#{@tc_bandwidth_limit4}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit4)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("4��������С����ֱ�����Ϊ10-1��5\6��10=0��10#0") {
						p "������С��������Ϊ:#{@tc_bandwidth_limit5}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit5)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")

						p "������С��������Ϊ:#{@tc_bandwidth_limit6}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit6)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")

						p "������С��������Ϊ:#{@tc_bandwidth_limit7}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit7)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")

						p "������С��������Ϊ:#{@tc_bandwidth_limit8}".to_gbk
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit8)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg1, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("5����������Ϊ�գ�����") {
						@options_page.set_client_bw(1, @tc_qos_ip1, @tc_qos_ip2, @ts_tag_bandensure, @tc_bandwidth_limit9)
						@options_page.save_traffic #����
						sleep @tc_wait_time
						error_tip = @options_page.error_msg
						assert_equal(@tc_qos_err_msg2, error_tip, "��ʾ��Ϣ���ݴ���!")
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
