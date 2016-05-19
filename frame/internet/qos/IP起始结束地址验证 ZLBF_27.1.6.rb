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
				@tc_bandwidth_empty = ""
				@tc_error_tip       = "�����������������"
				@tc_ip_error        = "��ַ��ֻ��������1-254"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ10000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #�����ܴ���
				}

				operate("2����ʼ��ַ��������ַ�������С�ֱ�Ϊ�գ��������") {
						tc_qos_ip   = "100"
						tc_qos_ip2  = "200"
						tc_empty_ip = "" #ip��ַΪ��
						#����ip��Χ�����õ�һ������
						#���ù���1���������Ƶ�IP,����ip��Χ
						puts "������ʼIP��ַΪ��".encode("GBK")
						puts "������ַΪ#{tc_qos_ip}".encode("GBK")
						puts "����Ϊ#{@tc_bandwidth_limit}".encode("GBK")
						@options_page.add_item
						@options_page.set_client_bw(1, tc_empty_ip, tc_qos_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_error_tip, error_tip, "��ʾ��Ϣ���ݴ���!")

						puts "��ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "�������IP��ַΪ��".encode("GBK")
						puts "����Ϊ#{@tc_bandwidth_limit}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_empty_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_error_tip, error_tip, "��ʾ��Ϣ���ݴ���!")

						#����ip��Χ�����õ�һ������
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						puts "����Ϊ��".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_empty)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_error_tip, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("3��������ƵĶԹ���1����ʼ������ַ�߽���в���") {
						#�߽�ֵ����
						#��ʼIP��ַ�±߽�
						tc_qos_ip  = "1"
						tc_qos_ip2 = "254"
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")

						#��ʼIP��ַ�ϱ߽�
						puts "������ʼIP��ַΪ#{tc_qos_ip2}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip2, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")

						# ����IP��ַ�±߽�
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")

						# ����IP��ַ�ϱ߽�
						puts "������ʼIP��ַΪ#{tc_qos_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("4������ʼIP�ͽ���IP����Ч�ȼ������") {
						#�߽�ֵԽ�����
						tc_qos_ip1     = "1"
						tc_qos_ip2     = "254"
						tc_qos_err_ip  = "0"
						tc_qos_err_ip2 = "255"

						#��ʼIP��ַ��Ч�ȼ���
						puts "������ʼIP��ַΪ#{tc_qos_err_ip}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_err_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "��ʾ��Ϣ���ݴ���!")

						puts "������ʼIP��ַΪ#{tc_qos_err_ip2}".encode("GBK")
						puts "������ַΪ#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_err_ip2, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "��ʾ��Ϣ���ݴ���!")

						#����IP��ַ��Ч�ȼ���
						puts "������ʼIP��ַΪ#{tc_qos_ip1}".encode("GBK")
						puts "������ַΪ#{tc_qos_err_ip}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip1, tc_qos_err_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "��ʾ��Ϣ���ݴ���!")

						puts "�������IP��ַΪ#{tc_qos_ip1}".encode("GBK")
						puts "������ַΪ#{tc_qos_err_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip1, tc_qos_err_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("5�����������쳣ֵ������������ĸ�����֣������ַ���С�������գ�0��ֵ��������棬�Ƿ��ܱ���ɹ�") {
						#�������
						tc_qos_ip      = "10"
						tc_qos_err_ip  = " " #�ո�
						tc_qos_err_ip2 = "��ַ" #����
						tc_qos_err_ip3 = "@" #����
						tc_qos_err_ip4 = "c" #��ĸ

						puts "��ʼIP��ַ��Ч�ȼ��࣬������Ч�ĵ�ַ�ᱻ�Զ�ɾ��".to_gbk
						puts "������ʼIP��ַΪ�ո�".encode("GBK") #�ո�
						@options_page.bw_ip_min0=tc_qos_err_ip
						sleep @tc_wait_time
						rs1=@options_page.bw_ip_min0
						assert_empty(rs1, "��ʼIP������ո�")

						puts "������ʼIP��ַΪ��#{tc_qos_err_ip2}".encode("GBK") #����
						@options_page.bw_ip_min0=tc_qos_err_ip2
						sleep @tc_wait_time
						rs2=@options_page.bw_ip_min0
						assert_empty(rs2, "��ʼIP����������:#{tc_qos_err_ip2}")

						puts "������ʼIP��ַΪ��#{tc_qos_err_ip3}".encode("GBK") #����
						@options_page.bw_ip_min0=tc_qos_err_ip3
						sleep @tc_wait_time
						rs3=@options_page.bw_ip_min0
						assert_empty(rs3, "��ʼIP�������������:#{tc_qos_err_ip3}")

						puts "������ʼIP��ַΪ��#{tc_qos_err_ip4}".encode("GBK") #��ĸ
						@options_page.bw_ip_min0=tc_qos_err_ip4
						sleep @tc_wait_time
						rs4=@options_page.bw_ip_min0
						assert_empty(rs4, "��ʼIP��������ĸ#{tc_qos_err_ip4}")

						puts "����IP��ַ��Ч�ȼ��࣬������Ч�ĵ�ַ�ᱻ�Զ�ɾ��".to_gbk
						puts "������ʼIP��ַΪ:#{tc_qos_ip}".encode("GBK") #�ո�
						puts "�������IP��ַΪ�ո�".encode("GBK")
						@options_page.bw_ip_min0=tc_qos_err_ip
						@options_page.bw_ip_max0=tc_qos_err_ip
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "����IP��ַ������ո�")

						puts "������ʼIP��ַΪ:#{tc_qos_ip}".encode("GBK") #����
						puts "�������IP��ַΪ��#{tc_qos_err_ip2}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip2
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "����IP��ַ�����룺#{tc_qos_err_ip2}")

						puts "������ʼIP��ַΪ:#{tc_qos_ip}".encode("GBK") #����
						puts "�������IP��ַΪ��#{tc_qos_err_ip3}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip3
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "����IP��ַ�����룺#{tc_qos_err_ip3}")

						puts "������ʼIP��ַΪ:#{tc_qos_ip}".encode("GBK") #��ĸ
						puts "�������IP��ַΪ��#{tc_qos_err_ip4}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip4
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "����IP��ַ�����룺#{tc_qos_err_ip4}")
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
