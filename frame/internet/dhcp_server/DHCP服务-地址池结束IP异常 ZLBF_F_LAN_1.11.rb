#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.11", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_lan_time   = 30
				@tc_lan_errend = "255"
		end

		def process

				operate("1����½·���������������ã�") {
				}

				operate("2������DHCP��ַ��Χ:192.168.100.100~255��") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@tc_lan_end_pre = @lan_page.lan_endip_pre
						@tc_lan_end     = @lan_page.lan_endip
						@tc_lan_endip  = @tc_lan_end_pre+@tc_lan_errend
						puts "�޸ĵ�ַ�ؽ�����ַΪ ##{@tc_lan_endip}".to_gbk
						@lan_page.lan_endip_set(@tc_lan_errend)
				}

				operate("3��������棻") {
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "IP��ַ���±߽糬����Χ��ʾ��Ϣ����")
						else
								sleep @tc_lan_time
								assert(false, "IP��ַ���±߽糬����ΧҲ�ܱ���")
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
