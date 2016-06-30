#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.24", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wifi_time = 40
				@tc_flag      = false
				@tc_linknum   = ""
				@tc_error_tip = "�����������ΧӦ��1��30֮��"
		end

		def process

				operate("1��������в������κ�ֵ���������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						puts "�޸�SSID1����������Ϊ��".to_gbk
						@wifi_page.modify_ssid1_linknum(@tc_linknum)
						puts "�޸�SSID2����������Ϊ��".to_gbk
						@wifi_page.modify_ssid2_linknum(@tc_linknum)
						puts "�޸�SSID3����������Ϊ��".to_gbk
						@wifi_page.modify_ssid3_linknum(@tc_linknum)
						puts "�޸�SSID4����������Ϊ��".to_gbk
						@wifi_page.modify_ssid4_linknum(@tc_linknum)
						if @wifi_page.ssid5?
								puts "�޸�SSID5����������Ϊ��".to_gbk
								@wifi_page.modify_ssid5_linknum(@tc_linknum)
						end
						if @wifi_page.ssid6?
								puts "�޸�SSID6����������Ϊ��".to_gbk
								@wifi_page.modify_ssid6_linknum(@tc_linknum)
						end
						if @wifi_page.ssid7?
								puts "�޸�SSID5����������Ϊ��".to_gbk
								@wifi_page.modify_ssid7_linknum(@tc_linknum)
						end
						if @wifi_page.ssid8?
								puts "�޸�SSID5����������Ϊ��".to_gbk
								@wifi_page.modify_ssid8_linknum(@tc_linknum)
						end
						@wifi_page.save_wifi_config

						link_num = @wifi_page.ssid1_link
						puts "��ѯ��SSID1���������Ϊ#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID1��������������Ϊ��ʱδ�Զ�������ֵ")

						link_num = @wifi_page.ssid2_link
						puts "��ѯ��SSID2���������Ϊ#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID2��������������Ϊ��ʱδ�Զ�������ֵ")

						link_num = @wifi_page.ssid3_link
						puts "��ѯ��SSID3���������Ϊ#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID3��������������Ϊ��ʱδ�Զ�������ֵ")

						link_num = @wifi_page.ssid4_link
						puts "��ѯ��SSID4���������Ϊ#{link_num}".to_gbk
						assert_equal(@ts_linknum_max, link_num, "SSID4��������������Ϊ��ʱδ�Զ�������ֵ")

						if @wifi_page.ssid5?
								link_num = @wifi_page.ssid5_link
								puts "��ѯ��SSID5���������Ϊ#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID6��������������Ϊ��ʱδ�Զ�������ֵ")
						end

						if @wifi_page.ssid6?
								link_num = @wifi_page.ssid6_link
								puts "��ѯ��SSID6���������Ϊ#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID6��������������Ϊ��ʱδ�Զ�������ֵ")
						end
						if @wifi_page.ssid7?
								link_num = @wifi_page.ssid7_link
								puts "��ѯ��SSID6���������Ϊ#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID7��������������Ϊ��ʱδ�Զ�������ֵ")
						end

						if @wifi_page.ssid8?
								link_num = @wifi_page.ssid8_link
								puts "��ѯ��SSID7���������Ϊ#{link_num}".to_gbk
								assert_equal(@ts_linknum_max, link_num, "SSID8��������������Ϊ��ʱδ�Զ�������ֵ")
						end
				}

				operate("2������SSID1��SSID8����ͬ��������") {
						#
				}


		end

		def clearup

		end

}
