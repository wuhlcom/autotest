#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.35", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_linknum1 = "����"
				@tc_linknum2 = "agzy"
				@tc_linknum3 = "~!%&_+$>?"
				@tc_link_num = ""
		end

		def process

				operate("1����������������ģ���������#{@tc_linknum1}���������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_5g_basic(@browser.url)
						puts "�޸�SSID1����������Ϊ����:#{@tc_linknum1}".to_gbk
						@wifi_page.modify_ssid1_linknum_5g(@tc_linknum1)
						link_num = @wifi_page.ssid1_link_5g
						assert_equal(@tc_link_num, link_num, "SSID1��������������Ϊ����δ�Զ����")

						puts "�޸�SSID2����������Ϊ����:#{@tc_linknum1}".to_gbk
						@wifi_page.modify_ssid2_linknum_5g(@tc_linknum1)
						link_num = @wifi_page.ssid2_link_5g
						assert_equal(@tc_link_num, link_num, "SSID2��������������Ϊ����δ�Զ����")

						puts "�޸�SSID3����������Ϊ����:#{@tc_linknum1}".to_gbk
						@wifi_page.modify_ssid3_linknum_5g(@tc_linknum)
						link_num = @wifi_page.ssid3_link_5g
						assert_equal(@tc_link_num, link_num, "SSID3��������������Ϊ����δ�Զ����")

						puts "�޸�SSID4����������Ϊ#{@tc_linknum1}".to_gbk
						@wifi_page.modify_ssid4_linknum_5g(@tc_linknum1)
						link_num = @wifi_page.ssid4_link_5g
						assert_equal(@tc_link_num, link_num, "SSID4��������������Ϊ����δ�Զ����")

						if @wifi_page.ssid5_5g?
								puts "�޸�SSID5����������Ϊ#{@tc_linknum1}".to_gbk
								@wifi_page.modify_ssid5_linknum_5g(@tc_linknum1)
								link_num = @wifi_page.ssid5_link_5g
								assert_equal(@tc_link_num, link_num, "SSID5��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid6_5g?
								puts "�޸�SSID5����������Ϊ#{@tc_linknum1}".to_gbk
								@wifi_page.modify_ssid6_linknum_5g(@tc_linknum1)
								link_num = @wifi_page.ssid6_link_5g
								assert_equal(@tc_link_num, link_num, "SSID6��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid7_5g?
								puts "�޸�SSID7����������Ϊ#{@tc_linknum1}".to_gbk
								@wifi_page.modify_ssid7_linknum_5g(@tc_linknum1)
								link_num = @wifi_page.ssid7_link_5g
								assert_equal(@tc_link_num, link_num, "SSID7��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid8_5g?
								puts "�޸�SSID8����������Ϊ#{@tc_linknum1}".to_gbk
								@wifi_page.modify_ssid8_linknum_5g(@tc_linknum1)
								link_num = @wifi_page.ssid8_link_5g
								assert_equal(@tc_link_num, link_num, "SSID8��������������Ϊ����δ�Զ����")
						end
				}

				operate("2���������������ĸ����������#{@tc_linknum2}���������") {
						puts "�޸�SSID1����������Ϊ��ĸ:#{@tc_linknum2}".to_gbk
						@wifi_page.modify_ssid1_linknum_5g(@tc_linknum2)
						link_num = @wifi_page.ssid1_link_5g
						assert_equal(@tc_link_num, link_num, "SSID1��������������Ϊ��ĸδ�Զ����")

						puts "�޸�SSID2����������Ϊ��ĸ:#{@tc_linknum2}".to_gbk
						@wifi_page.modify_ssid2_linknum_5g(@tc_linknum2)
						link_num = @wifi_page.ssid2_link_5g
						assert_equal(@tc_link_num, link_num, "SSID2��������������Ϊ��ĸδ�Զ����")

						puts "�޸�SSID3����������Ϊ��ĸ:#{@tc_linknum2}".to_gbk
						@wifi_page.modify_ssid3_linknum_5g(@tc_linknum2)
						link_num = @wifi_page.ssid3_link_5g
						assert_equal(@tc_link_num, link_num, "SSID3��������������Ϊ��ĸδ�Զ����")

						puts "�޸�SSID4����������Ϊ��ĸ��#{@tc_linknum2}".to_gbk
						@wifi_page.modify_ssid4_linknum_5g(@tc_linknum2)
						link_num = @wifi_page.ssid4_link_5g
						assert_equal(@tc_link_num, link_num, "SSID4��������������Ϊ��ĸδ�Զ����")

						if @wifi_page.ssid5_5g?
								puts "�޸�SSID5����������Ϊ��ĸ#{@tc_linknum2}".to_gbk
								@wifi_page.modify_ssid5_linknum_5g(@tc_linknum2)
								link_num = @wifi_page.ssid5_link_5g
								assert_equal(@tc_link_num, link_num, "SSID5��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid6_5g?
								puts "�޸�SSID5����������Ϊ��ĸ#{@tc_linknum2}".to_gbk
								@wifi_page.modify_ssid6_linknum_5g(@tc_linknum2)
								link_num = @wifi_page.ssid6_link_5g
								assert_equal(@tc_link_num, link_num, "SSID6��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid7_5g?
								puts "�޸�SSID7����������Ϊ��ĸ#{@tc_linknum2}".to_gbk
								@wifi_page.modify_ssid7_linknum_5g(@tc_linknum2)
								link_num = @wifi_page.ssid7_link_5g
								assert_equal(@tc_link_num, link_num, "SSID7��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid8_5g?
								puts "�޸�SSID8����������Ϊ��ĸ#{@tc_linknum2}".to_gbk
								@wifi_page.modify_ssid8_linknum_5g(@tc_linknum2)
								link_num = @wifi_page.ssid8_link_5g
								assert_equal(@tc_link_num, link_num, "SSID7��������������Ϊ����δ�Զ����")
						end
				}

				operate("3������������������ַ�����������#{@tc_linknum3}���������") {
						puts "�޸�SSID1����������Ϊ����:#{@tc_linknum3}".to_gbk
						@wifi_page.modify_ssid1_linknum_5g(@tc_linknum3)
						link_num = @wifi_page.ssid1_link_5g
						assert_equal(@tc_link_num, link_num, "SSID1��������������Ϊ����δ�Զ����")

						puts "�޸�SSID2����������Ϊ��ĸ:#{@tc_linknum3}".to_gbk
						@wifi_page.modify_ssid2_linknum_5g(@tc_linknum3)
						link_num = @wifi_page.ssid2_link_5g
						assert_equal(@tc_link_num, link_num, "SSID2��������������Ϊ����δ�Զ����")

						puts "�޸�SSID3����������Ϊ��ĸ:#{@tc_linknum3}".to_gbk
						@wifi_page.modify_ssid3_linknum_5g(@tc_linknum3)
						link_num = @wifi_page.ssid3_link_5g
						assert_equal(@tc_link_num, link_num, "SSID3��������������Ϊ����δ�Զ����")

						puts "�޸�SSID4����������Ϊ��ĸ��#{@tc_linknum3}".to_gbk
						@wifi_page.modify_ssid4_linknum_5g(@tc_linknum3)
						link_num = @wifi_page.ssid4_link_5g
						assert_equal(@tc_link_num, link_num, "SSID4��������������Ϊ����δ�Զ����")

						if @wifi_page.ssid5_5g?
								puts "�޸�SSID5����������Ϊ��ĸ#{@tc_linknum3}".to_gbk
								@wifi_page.modify_ssid5_linknum_5g(@tc_linknum3)
								link_num = @wifi_page.ssid5_link_5g
								assert_equal(@tc_link_num, link_num, "SSID5��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid6_5g?
								puts "�޸�SSID6����������Ϊ��ĸ#{@tc_linknum3}".to_gbk
								@wifi_page.modify_ssid6_linknum_5g(@tc_linknum3)
								link_num = @wifi_page.ssid6_link_5g
								assert_equal(@tc_link_num, link_num, "SSID6��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid7_5g?
								puts "�޸�SSID7����������Ϊ��ĸ#{@tc_linknum3}".to_gbk
								@wifi_page.modify_ssid7_linknum_5g(@tc_linknum3)
								link_num = @wifi_page.ssid7_link_5g
								assert_equal(@tc_link_num, link_num, "SSID7��������������Ϊ����δ�Զ����")
						end

						if @wifi_page.ssid8_5g?
								puts "�޸�SSID8����������Ϊ��ĸ#{@tc_linknum3}".to_gbk
								@wifi_page.modify_ssid8_linknum_5g(@tc_linknum3)
								link_num = @wifi_page.ssid8_link_5g
								assert_equal(@tc_link_num, link_num, "SSID7��������������Ϊ����δ�Զ����")
						end
				}

				operate("4������SSID1��SSID8����ͬ��������") {

				}


		end

		def clearup

		end

}
