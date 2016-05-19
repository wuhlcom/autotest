#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.6", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_err_info          = "������ַӦ���ڿ�ʼ��ַ"
				@tc_lan_default_start = "100"
				@tc_lan_default_end   = "200"
				@tc_lan_end           = "10"
				@tc_lan_time          = 35
		end

		def process

				operate("1����½·���������������ã�") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2������DHCP��ַ��Χ��192.168.100.100~10��") {
						tc_lan_start_pre = @lan_page.lan_startip_pre
						tc_lan_start     = @lan_page.lan_startip
						tc_lan_startip   = tc_lan_start_pre+tc_lan_start
						tc_lan_end_pre   = @lan_page.lan_endip_pre
						tc_lan_end       = @lan_page.lan_endip
						tc_lan_endip     =tc_lan_end_pre+tc_lan_end
						puts "��ǰ��ַ�ط�ΧΪ #{tc_lan_startip}-#{tc_lan_endip}".to_gbk
						@lan_page.lan_startip_set(@tc_lan_default_start)
						@lan_page.lan_endip_set(@tc_lan_end)
				}

				operate("3��������棻") {
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_err_info
								assert_equal(@tc_err_info, @lan_page.lan_error.strip, "IP��ַ�ؽ�����ַС����ʼ��ַҲ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "IP��ַ�ؽ�����ַС����ʼ��ַ�����쳣")
						end
				}


		end

		def clearup

				operate("1 �ָ�Ĭ����ʼ��ַ��Χ") {
						unless @lan_page.nil?
								@browser.refresh
								@lan_page.open_lan_page(@browser.url)
								tc_lan_start = @lan_page.lan_startip
								tc_lan_end   = @lan_page.lan_endip
								flag         =false
								unless tc_lan_start == @tc_lan_default_start
										puts "�ָ�Ĭ����ʼ��ַ".to_gbk
										@lan_page.lan_startip_set(@tc_lan_default_start)
										flag=true
								end
								unless tc_lan_end == @tc_lan_default_end
										puts "�ָ�Ĭ�Ͻ�����ַ".to_gbk
										@lan_page.lan_endip_set(@tc_lan_default_start)
										flag =true
								end
								if flag
										@lan_page.btn_save_lanset
								end
						end
				}
		end

}
