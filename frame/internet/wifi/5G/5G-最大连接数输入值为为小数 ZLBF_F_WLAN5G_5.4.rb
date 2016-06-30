#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.33", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_linknum   = "1.1"
				@tc_link_num  = "11"
				@tc_wifi_time = 40
		end

		def process

				operate("1�������������С���㣬��������#{@tc_linknum}���������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						puts "�޸�SSID1����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid1_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid1_link_5g
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID1��������������ΪС��δ�Զ����С����")

						puts "�޸�SSID2����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid2_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid2_link_5g
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID2��������������ΪС��δ�Զ����С����")

						puts "�޸�SSID3����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid3_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid3_link_5g
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID3��������������ΪС��δ�Զ����С����")

						puts "�޸�SSID4����������Ϊ#{@tc_linknum}".to_gbk
						@wifi_page.modify_ssid4_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid4_link_5g
						puts "��ѯ�����������Ϊ#{link_num}".to_gbk
						assert_equal(@tc_link_num, link_num, "SSID4��������������ΪС��δ�Զ����С����")

						if @wifi_page.ssid5_5g?
								puts "�޸�SSID5����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid5_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid5_link_5g
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID5��������������ΪС��δ�Զ����С����")
						end

						if @wifi_page.ssid6_5g?
								puts "�޸�SSID6����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid6_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid6_link_5g
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID6��������������ΪС��δ�Զ����С����")
						end

						if @wifi_page.ssid7_5g?
								puts "�޸�SSID7����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid7_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid7_link_5g
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID7��������������ΪС��δ�Զ����С����")
						end

						if @wifi_page.ssid8_5g?
								puts "�޸�SSID8����������Ϊ#{@tc_linknum}".to_gbk
								@wifi_page.modify_ssid8_linknum_5g(@tc_linknum)
								link_num = @wifi_page.ssid8_link_5g
								puts "��ѯ�����������Ϊ#{link_num}".to_gbk
								assert_equal(@tc_link_num, link_num, "SSID8��������������ΪС��δ�Զ����С����")
						end
				}

				operate("2������SSID1��SSID8����ͬ��������") {

				}


		end

		def clearup

		end

}
