#
# description:
# �����ַ�:�ո�,"@",".","-"
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_lan_time          = 35
				@tc_operate_time      = 1
				@tc_error_no_startip  = "������DHCP��ʼ��ַ"
				@tc_error_no_endip    = "������DHCP������ַ"
				@tc_error_not_same_seg= "DHCP��ַ�;�����IP����ͬһ����"
				@tc_error_ip_format   = "DHCP��ַ��ʽ����"
				@tc_addr_special0     = ""
				@tc_addr_special1     = " "
				@tc_addr_special2     = "@"
				@tc_addr_special3     = "."
				@tc_addr_special4     = "\/"
		end

		def process

				operate("1����½·����������������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2������DHCP��ַ�����������ַ���") {
						@tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_start     = @lan_page.lan_startip
						@tc_lan_startip   = @tc_lan_start_pre+@tc_lan_start

						@tc_lan_end_pre = @lan_page.lan_endip_pre
						@tc_lan_end     = @lan_page.lan_endip
						@tc_lan_endip   = @tc_lan_end_pre+@tc_lan_end

						puts "Current LAN DHCP Server pool start ip:#{@tc_lan_startip}"
						puts "Current LAN DHCP Server pool end ip:#{@tc_lan_endip}"
						#######################special1#########
						puts "�������ַ".encode("GBK")
						puts "�������ַ��ʼIP".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special0)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_error_no_startip
								assert_equal(@tc_error_no_startip, @lan_page.lan_error.strip, "��ַ����ʼ��������ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ������δ��ʾ����")
						end
						sleep @tc_operate_time
						puts "�������ַ����IP".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special0)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_error_no_endip
								assert_equal(@tc_error_no_endip, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ��������ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ������δ��ʾ����")
						end
						sleep @tc_operate_time
						#######################special1#########
						puts "��ַ����ո�".encode("GBK")
						puts "�޸���ʼIPΪ�ո�".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special1)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ����ʼ��ַ�ո���ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ����ո�δ��ʾ����")
						end
						sleep @tc_operate_time
						puts "�޸Ľ���IPΪ�ո�".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special1)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ����ո���ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ����ո�δ��ʾ����")
						end
						sleep @tc_operate_time
						############################special2######################
						puts "��ַ���������ַ�'#{@tc_addr_special2}'".encode("GBK")
						puts "�޸���ʼIPΪ��'#{@tc_addr_special2}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special2)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ����ʼ��ַ���������ַ�'#{@tc_addr_special2}'��ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ���������ַ�'#{@tc_addr_special2}'δ��ʾ����")
						end
						sleep @tc_operate_time
						puts "�޸Ľ���IPΪ��'#{@tc_addr_special2}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special2)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ���������ַ�'#{@tc_addr_special2}'��ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ���������ַ�'#{@tc_addr_special2}'δ��ʾ����")
						end
						sleep @tc_operate_time
						############################special3######################
						puts "��ַ���������ַ�'#{@tc_addr_special3}'".encode("GBK")
						puts "�޸���ʼIPΪ��'#{@tc_addr_special3}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special3)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ����ʼ��ַ���������ַ�'#{@tc_addr_special3}'��ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ���������ַ�'#{@tc_addr_special3}'δ��ʾ����")
						end
						sleep @tc_operate_time
						puts "�޸Ľ���IPΪ��'#{@tc_addr_special3}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special3)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ���������ַ�'#{@tc_addr_special3}'��ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ���������ַ�'#{@tc_addr_special3}'δ��ʾ����")
						end
						sleep @tc_operate_time
						############################special4######################
						puts "��ַ���������ַ�'#{@tc_addr_special4}'".encode("GBK")
						puts "�޸���ʼIPΪ��'#{@tc_addr_special4}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_addr_special4)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ����ʼ��ַ���������ַ�'#{@tc_addr_special4}'��ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ����ʼ��ַ���������ַ�'#{@tc_addr_special4}'δ��ʾ����")
						end
						sleep @tc_operate_time
						puts "�޸Ľ���IPΪ��'#{@tc_addr_special4}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(@tc_addr_special4)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "��ַ�ؽ�����ַ���������ַ�'#{@tc_addr_special4}'��ʾ����")
						else
								sleep @tc_lan_time
								assert(false, "��ַ�ؽ�����ַ���������ַ�'#{@tc_addr_special4}'δ��ʾ����")
						end
						sleep @tc_operate_time
				}

				operate("3���������") {
						#��һ������ɴ˲���
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
