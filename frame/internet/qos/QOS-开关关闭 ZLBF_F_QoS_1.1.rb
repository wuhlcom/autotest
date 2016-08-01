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

				@tc_bw_error = "�빴ѡIP������ƣ�������д������Ĵ����С"
				@tc_total_bw = "10000"

		end

		def process

				operate("1������DUT��������ҳ�棬ȥ��ѡ������IP������ơ�ѡ���") {
						####δ���ÿ������ʱ����ͳ��
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2�������ܴ���") {
						@options_page.unselect_traffic_sw #�رմ������
						@options_page.set_total_bw(@tc_total_bw)
				}

				operate("	3������") {
						@options_page.save_traffic #�ύ
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error, error_msg, "δ��ʾ����ʧ��")
				}

		end

		def clearup

		end

}
