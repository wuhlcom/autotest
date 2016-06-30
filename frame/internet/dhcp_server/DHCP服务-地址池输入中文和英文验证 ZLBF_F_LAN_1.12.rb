#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.13", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_lan_time = 35
		end

		def process

				operate("1����½·����������������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2������DHCP��ַ���������ĺ�Ӣ�ģ�") {
						@tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_start     = @lan_page.lan_startip
						@tc_lan_startip   = @tc_lan_start_pre+@tc_lan_start

						@tc_lan_end_pre = @lan_page.lan_endip_pre
						@tc_lan_end     = @lan_page.lan_endip
						@tc_lan_endip   = @tc_lan_end_pre+@tc_lan_end

						puts "Current LAN DHCP Server pool start ip:#{@tc_lan_startip}"
						puts "Current LAN DHCP Server pool end ip:#{@tc_lan_endip}"

						puts "��ַ��������".encode("GBK")
						address_ch = "��ַ"
						puts "�޸���ʼIPΪ��'#{address_ch}'".encode("GBK")
						@lan_page.lan_startip_set(address_ch)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ����ʼ��ַ����������ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ��������Ҳ�ܱ���")
						end

						puts "�޸Ľ���IPΪ��'#{address_ch}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(address_ch)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ����������ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ��������Ҳ�ܱ���")
						end

						puts "IP��ַ����Ӣ��".encode("GBK")
						address_en = "IP"
						puts "�޸���ʼIPΪ��'#{address_en}'".encode("GBK")
						@lan_page.lan_startip_set(address_en)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ����ʼ��ַ����Ӣ����ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ��������Ҳ�ܱ���")
						end

						puts "�޸Ľ���IPΪ��'#{address_en}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(address_en)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ����Ӣ����ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ����Ӣ��Ҳ�ܱ���")
						end
				}

				operate("3���������") {
						#�ڶ����Ѿ�ʵ��
				}


		end

		def clearup

				operate("1 �ָ�Ĭ����ʼ��ַ��Χ") {
						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						flag         = false
						#�ָ�Ĭ����ʼ��ַ
						unless (!@tc_lan_start.nil? && tc_lan_start == @tc_lan_start)
								puts "�ָ�Ĭ����ʼ��ַ".to_gbk
								@lan_page.lan_startip_set(@tc_lan_start)
								flag= true
						end

						#�ָ�Ĭ�Ͻ�����ַ
						unless (!@tc_lan_end.nil? && tc_lan_end == @tc_lan_end)
								puts "�ָ�Ĭ�Ͻ�����ַ".to_gbk
								@lan_page.lan_endip_set(@tc_lan_end)
								flag= true
						end

						if flag
								@lan_page.btn_save_lanset
						end
				}
		end

}
