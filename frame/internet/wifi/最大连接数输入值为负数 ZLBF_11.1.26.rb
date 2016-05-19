#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.26", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_linknum  = "-30"
				@tc_link_num = "30"
		end

		def process

				operate("1������������븺�����������롰-1�����������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						puts "�޸�SSID1����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid1_linknum(@tc_linknum)
						link_num = @wifi_page.ssid1_link
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID1��������������Ϊ����δ�Զ�ȥ������")

						puts "�޸�SSID2����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid2_linknum(@tc_linknum)
						link_num = @wifi_page.ssid2_link
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID2������������������Ϊ����δ�Զ�ȥ������")

						puts "�޸�SSID3����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid3_linknum(@tc_linknum)
						link_num = @wifi_page.ssid3_link
						puts "��ѯ�����������Ϊ#{link_num}"
						assert_equal(@tc_link_num, link_num, "SSID3��������������Ϊ����δ�Զ�ȥ������")

						puts "�޸�SSID4����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid4_linknum(@tc_linknum)
						link_num = @wifi_page.ssid4_link
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID4��������������Ϊ����δ�Զ�ȥ������")

						if @wifi_page.ssid5?
								puts "�޸�SSID5����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid5_linknum(@tc_linknum)
								link_num = @wifi_page.ssid5_link
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID5��������������Ϊ����δ�Զ�ȥ������")
						end

						if @wifi_page.ssid6?
								puts "�޸�SSID6����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid6_linknum(@tc_linknum)
								link_num = @wifi_page.ssid6_link
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID6��������������Ϊ����δ�Զ�ȥ������")
						end

						if @wifi_page.ssid7?
								puts "�޸�SSID7����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid7_linknum(@tc_linknum)
								link_num = @wifi_page.ssid7_link
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID7��������������Ϊ����δ�Զ�ȥ������")
						end

						if @wifi_page.ssid8?
								puts "�޸�SSID8����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid8_linknum(@tc_linknum)
								link_num = @wifi_page.ssid8_link
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID8��������������Ϊ����δ�Զ�ȥ������")
						end
				}

				operate("2������SSID1��SSID8����ͬ��������") {

				}

		end

		def clearup

		end

}
