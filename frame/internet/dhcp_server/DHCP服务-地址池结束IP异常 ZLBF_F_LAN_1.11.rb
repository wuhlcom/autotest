#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.11", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_lan_time    = 30
				@tc_lan_errend1 = "255"
				@tc_lan_errend2 = "0"
		end

		def process

				operate("1����½·���������������ã�") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@tc_lan_end_pre = @lan_page.lan_endip_pre
				}

				operate("2����ַ����ʼIP����Ϊ����IP") {
						@tc_lan_end = @lan_page.lan_endip
						tc_lan_endip  = @tc_lan_end_pre+@tc_lan_errend1
						puts "�޸ĵ�ַ����ʼ��ַΪ #{tc_lan_endip}".to_gbk
						@lan_page.lan_endip_set(@tc_lan_errend1)
				}

				operate("3������DHCP��ʼIP��ַ�ֱ�Ϊ:0��255��") {
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "IP��ַ���ϱ߽糬����Χ��ʾ��Ϣ����")
						else
								sleep @tc_lan_time
								assert(false, "IP��ַ���ϱ߽糬����ΧҲ�ܱ���")
						end
				}

				operate("4���ֱ������棻") {
						tc_lan_endip = @tc_lan_end_pre+@tc_lan_errend2
						puts "�޸ĵ�ַ����ʼ��ַΪ #{tc_lan_endip}".to_gbk
						@lan_page.lan_endip_set(@tc_lan_errend2)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "IP��ַ���ϱ߽糬����Χ��ʾ��Ϣ����")
						else
								sleep @tc_lan_time
								assert(false, "IP��ַ���ϱ߽糬����ΧҲ�ܱ���")
						end
				}
		end

		def clearup

				operate("1 �ָ�Ĭ�Ͻ�����ַ��Χ") {
						unless @tc_lan_end.nil?
								@browser.refresh
								@lan_page.open_lan_page(@browser.url)
								tc_lan_end = @lan_page.lan_endip
								unless tc_lan_end == @tc_lan_end
										@lan_page.lan_endip_set(@tc_lan_end)
										@lan_page.btn_save_lanset
								end
						end
				}
		end


}
