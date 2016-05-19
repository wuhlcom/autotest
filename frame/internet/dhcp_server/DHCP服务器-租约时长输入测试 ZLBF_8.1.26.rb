#
# description:
##ֻ��Ҫ����߽�ֵ������һ��ȼ���ֵһ�����ϱ߽��1���±߽��1,���ֵ�����Լ���
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.26", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_lease_error   = "��Լʱ�䷶ΧΪ60-43200" #SDK
				@tc_lease_time1   = "59"
				@tc_lease_time2   = "60" #�߽�ֵ
				@tc_lease_time3   = "1800" #�ȼ�ֵ
				@tc_lease_time4   = "43200" #�߽�ֵ
				@tc_lease_time5   = "43201"
				@tc_lan_time      = 30
		end

		def process

				operate("1����½·����������������") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2��������Լʱ������#{@tc_lease_time1}�룬#{@tc_lease_time2}�룬#{@tc_lease_time3}�룬#{@tc_lease_time4}�룬#{@tc_lease_time5}��") {
						puts "��������Ϊ:#{@tc_lease_time1}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time1)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "��������Ϊ:#{@tc_lease_time1}Ҳ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "��������Ϊ:#{@tc_lease_time1}δ��ʾ���ڴ���")
						end

						puts "��������Ϊ:#{@tc_lease_time2}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time2)
						@lan_page.btn_save_lanset
						@lan_page.open_lan_page(@browser.url)
						curr_lease=@lan_page.dhcp_lease
						assert_equal(@tc_lease_time2, curr_lease, "��������Ϊ��Сֵ#{@tc_lease_time2}ʧ��")

						puts "��������Ϊ:#{@tc_lease_time3}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time3)
						@lan_page.btn_save_lanset
						@lan_page.open_lan_page(@browser.url)
						curr_lease=@lan_page.dhcp_lease
						assert_equal(@tc_lease_time3, curr_lease, "��������Ϊ#{@tc_lease_time3}ʧ��")

						puts "��������Ϊ:#{@tc_lease_time4}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time4)
						@lan_page.btn_save_lanset
						@lan_page.open_lan_page(@browser.url)
						curr_lease=@lan_page.dhcp_lease
						assert_equal(@tc_lease_time4, curr_lease, "��������Ϊ#{@tc_lease_time4}ʧ��")

						puts "��������Ϊ:#{@tc_lease_time5}".to_gbk
						@lan_page.dhcp_lease_set(@tc_lease_time5)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@tc_lease_error
								assert_equal(@tc_lease_error, @lan_page.lan_error.strip, "��������Ϊ:#{@tc_lease_time5}Ҳ���Ա���")
						else
								sleep @tc_lan_time
								assert(false, "��������Ϊ:#{@tc_lease_time5}δ��ʾ���ڴ���")
						end
				}

				operate("3���������") {

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
