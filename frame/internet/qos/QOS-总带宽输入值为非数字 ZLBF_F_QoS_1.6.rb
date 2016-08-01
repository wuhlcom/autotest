#
# description:
# ����Ĭ��״̬������
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				# 				1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ���
				# 				2�������������Ϊ�������"`~!@#$%^&*()_+{}:"|>?<-=[];'\/.,",����
				# 3�������������Ϊ��ĸ��"10abzjb",����
				# 4�������������Ϊ����"����"������
				@tc_bw1       ="1000&"
				@tc_bw2       ="#2500"
				@tc_bw3       ="1000-0"
				@tc_bw4       ="1000bf0"
				@tc_bw5       ="1020����"
				@tc_bw_error1 ="ֻ������������"
		end

		def process

				operate("1������DUT �������ҳ�棬��ѡ������IP������ơ�ѡ���") {
						####δ���ÿ������ʱ����ͳ��
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2�������������Ϊ�������`~!@#$%^&*()_+{}:\"|>?<-=[];\'\/.,,����") {
						puts "�����ܴ���Ϊ#{@tc_bw1}".to_gbk
						@options_page.select_traffic_sw #���ܴ������
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #�ύ
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "δ��ʾ����ʧ��")

						puts "�����ܴ���Ϊ#{@tc_bw2}".to_gbk
						@options_page.select_traffic_sw #���ܴ������
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #�ύ
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "δ��ʾ����ʧ��")

						puts "�����ܴ���Ϊ#{@tc_bw3}".to_gbk
						@options_page.select_traffic_sw #���ܴ������
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #�ύ
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "δ��ʾ����ʧ��")
				}

				operate("3�������������Ϊ��ĸ��'10abzjb',����") {
						puts "�����ܴ���Ϊ#{@tc_bw4}".to_gbk
						@options_page.select_traffic_sw #���ܴ������
						@options_page.set_total_bw(@tc_bw4)
						@options_page.save_traffic #�ύ
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "δ��ʾ����ʧ��")
				}

				operate("4�������������Ϊ����'����'������") {
						puts "�����ܴ���Ϊ#{@tc_bw5}".to_gbk
						@options_page.select_traffic_sw #���ܴ������
						@options_page.set_total_bw(@tc_bw5)
						@options_page.save_traffic #�ύ
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "δ��ʾ����ʧ��")
				}
		end

		def clearup
				operate("1 �ָ�Ĭ�ϴ�������") {
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
