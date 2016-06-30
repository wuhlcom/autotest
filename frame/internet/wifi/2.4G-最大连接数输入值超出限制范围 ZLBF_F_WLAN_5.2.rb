#
# description:
# author:wuhongliang
# date:2016-03-12 11:16:13
# modify:
#
testcase {
		attr = {"id" => "ZLBF_11.1.23", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wifi_time = 40
				@tc_flag      = false
				@tc_error_tip = "�����������ΧӦ��1��30֮��"
		end

		def process

				operate("1�������������#{@ts_linknum_less}���������") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						puts "�޸�SSID1����������Ϊ#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID1��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
						end

						puts "�޸�SSID2����������Ϊ#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID2��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
						end

						puts "�޸�SSID3����������Ϊ#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID3��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
						end

						puts "�޸�SSID4����������Ϊ#{@ts_linknum_less}".to_gbk
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_less)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID4��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
						end

						if @wifi_page.ssid5?
								puts "�޸�SSID5����������Ϊ#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID5��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
								end
						end

						if @wifi_page.ssid6?
								puts "�޸�SSID6����������Ϊ#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID6��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
								end
						end

						if @wifi_page.ssid7?
								puts "�޸�SSID7����������Ϊ#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID7��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
								end
						end

						if @wifi_page.ssid8?
								puts "�޸�SSID8����������Ϊ#{@ts_linknum_less}".to_gbk
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_less)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID8��������������Ϊ#{@ts_linknum_less}Ҳ�ܱ���")
								end
						end
				}

				operate("2�������������#{@ts_linknum_more}��������棻") {
						@browser.refresh
						@wifi_page.select_2g_basic(@browser.url)
						puts "�޸�SSID1����������Ϊ#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID1��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
						end

						puts "�޸�SSID2����������Ϊ#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID2��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
						end

						puts "�޸�SSID3����������Ϊ#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID3��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
						end

						puts "�޸�SSID4����������Ϊ#{@ts_linknum_more}".to_gbk
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_more)
						@wifi_page.save_wifi
						error_tip = @wifi_page.wifi_error
						puts "ERROR TIP:#{error_tip}".to_gbk
						unless error_tip == @tc_error_tip
								@tc_flag = true
								assert(false, "SSID4��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
						end

						if @wifi_page.ssid5?
								puts "�޸�SSID5����������Ϊ#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid5_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID5��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
								end
						end

						if @wifi_page.ssid6?
								puts "�޸�SSID6����������Ϊ#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid6_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID6��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
								end
						end

						if @wifi_page.ssid7?
								puts "�޸�SSID7����������Ϊ#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid7_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID7��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
								end
						end

						if @wifi_page.ssid8?
								puts "�޸�SSID8����������Ϊ#{@ts_linknum_more}".to_gbk
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
								@wifi_page.modify_ssid8_linknum(@ts_linknum_more)
								@wifi_page.save_wifi
								error_tip = @wifi_page.wifi_error
								puts "ERROR TIP:#{error_tip}".to_gbk
								unless error_tip == @tc_error_tip
										@tc_flag = true
										assert(false, "SSID8��������������Ϊ#{@ts_linknum_more}Ҳ�ܱ���")
								end
						end
				}

				operate("3������SSID1��SSID8����ͬ��������") {
						#
				}

		end

		def clearup

				operate("1 �ָ�Ĭ������") {
						if @tc_flag
								sleep @tc_wifi_time
						end
						#����������ʽҲ�ܱ���Ļ�������Ҫ�ȴ��䱣�����
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.select_2g_basic(@browser.url)
						#�޸ĵ�һ��SSID����
						@wifi_page.modify_ssid1_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid2_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid3_linknum(@ts_linknum_max)
						@wifi_page.modify_ssid4_linknum(@ts_linknum_max)
						if @wifi_page.ssid5?
								@wifi_page.modify_ssid5_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid6?
								@wifi_page.modify_ssid6_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid7?
								@wifi_page.modify_ssid7_linknum(@ts_linknum_max)
						end
						if @wifi_page.ssid8?
								@wifi_page.modify_ssid8_linknum(@ts_linknum_max)
						end
						@wifi_page.save_wifi_config
				}

		end

}
