#
# description:
# ��Ʒ����:��Լ��������60@�����ֿ�ͷ+������ŵ���Լ
# author:wuhongliang
# date:2015-10-29 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.27", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_lease_time1  = ""
				@tc_lease_time2  = " "
				@tc_lease_time3  = "1000@"
				@tc_lease_time4  = "!800"
				@tc_lease_time5  = "*****"
				# @tc_lease_error = "��Լʱ�䷶ΧΪ60-43200"
				@tc_lease_error  = "����ʱ��ֻ����������"
				@tc_lease_error1 = "����������ʱ��"
				@tc_lan_time     = 30
		end

		def process

				operate("1����½·����������������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2��������Լʱ�����������ַ���") {
						puts "�������ڿ�".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time1)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error1
								assert_equal(@tc_lease_error1, @lan_page.lan_error.strip, "��������Ϊ��Ҳ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "��������Ϊ��δ��ʾ���ڴ���")
						end

						puts "��������Ϊ�ո�".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time2)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "��������Ϊ�ո�Ҳ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "��������Ϊ�ո�δ��ʾ���ڴ���")
						end

						puts "��������Ϊ#{@tc_lease_time4}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time4)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "��������Ϊ#{@tc_lease_time4}Ҳ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "��������Ϊ#{@tc_lease_time4}δ��ʾ���ڴ���")
						end

						puts "��������Ϊ#{@tc_lease_time5}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time5)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "��������Ϊ#{@tc_lease_time5}Ҳ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "��������Ϊ#{@tc_lease_time5}δ��ʾ���ڴ���")
						end
				}

				operate("3���������") {
						#�ڶ�����ʵ��
				}


		end

		def clearup
				operate("1 �ָ�Ĭ����ʼ��ַ��Χ") {
						unless @lan_page.nil?
								@browser.refresh
								@lan_page.open_lan_page(@browser.url)
								dhcp_lease = @lan_page.dhcp_lease
								unless dhcp_lease == @ts_default_leasetime
										puts "�ָ�����Ϊ#{@ts_default_leasetime}".to_gbk
										@lan_page.dhcp_lease_set(@ts_default_leasetime)
										@lan_page.btn_save_lanset
								end
						end
				}
		end

}
