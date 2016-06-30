#
# description:
#ֻҪ�������¼�������Ϳ��Ը��ǵ����п��ܵ��쳣
#����ԭ��:�¹������ʼ�ͽ���IPҪô��С�����й�����±߽磬Ҫô���������й�����ϱ߽�
#���ǿɵó��������������a,bΪ����1,�����ҴӴ�С��������
# 1--(x,a)(a b) ,2--(a b) (b,y),3--x (a b) y
#����1Ϊһ��IP��Χ������2ΪIP��Χ���ϱ߽磬�±߽������1�ص������1�ڹ���2�ķ�Χ��
#����1Ϊһ��IP��ַ��������ֻҪIP��Χ�Ĳ���ͨ����������Ҳ��ͨ����
#2015 12 17 bug δ���ϱ߽�ĺϷ��������
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				#kpbs
				@tc_bandwidth_total = 100000
				@tc_bandwidth_limit = 8000
				@tc_wait_time       = 2

				#rule1@tc_rule1_ip1
				@tc_rule1_ip1       = "100"
				@tc_rule1_ip2       = "110"
				#�ϱ߽���tc_rule1_ip1��һ��
				@tc_rule2_ip1       = "50"
				@tc_rule2_ip2       = "100"
				#�±߽���tc_rule1_ip1��һ��
				@tc_rule3_ip1       = "110"
				@tc_rule3_ip2       = "120"
				#rule1�ڷ�Χ��
				@tc_rule4_ip1       = "90"
				@tc_rule4_ip2       = "120"
				@tc_rule_error      = "�����ཻ��IP��"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ��������������Ϊ1000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total)
				}

				operate("2�����赱ǰLAN�ڵ�ַΪ192.168.100.1�����ù���1��ַ��Ϊ192.168,100.2��192.168,100.2") {
						#�ڶ����Ľ�����Χ���һ������ʼ��Χ���
						#���ù���1���������Ƶ�IP,����ip��Χ
						puts "rule 1 ip start ip #{@tc_rule1_ip1},end ip #{@tc_rule1_ip2}"
						@options_page.add_item
						@options_page.set_client_bw(1, @tc_rule1_ip1, @tc_rule1_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)

						puts "rule 2 ip start ip #{@tc_rule2_ip1},end ip #{@tc_rule2_ip2}"
						#���ù���2���������Ƶ�IP,����ip��Χ
						@options_page.add_item
						@options_page.set_client_bw(2, @tc_rule1_ip1, @tc_rule1_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #����
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("3�����ù���2��ַ��ҲΪ192.168,100.2��192.168,100.2���Ƿ������óɹ�") {
						#�ڶ�����ʼ��Χ���һ���Ľ�����Χ���
						@options_page.set_client_bw(2, @tc_rule3_ip1, @tc_rule3_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #�ύ
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

				operate("4���������ù���1��ַ��Ϊ192.168,100.2��192.168,100.3�����ù���2��ַ��Ϊ192.168,100.3��192.168,100.4���Ƿ������óɹ�") {
						#�ڶ�����Χ������һ����Χ
						@options_page.set_client_bw(2, @tc_rule4_ip1, @tc_rule4_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #�ύ
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_rule_error, error_tip, "��ʾ��Ϣ���ݴ���!")
				}

		end

		def clearup

				operate("1 ɾ�������������") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #�ύ
				}

		end

}
