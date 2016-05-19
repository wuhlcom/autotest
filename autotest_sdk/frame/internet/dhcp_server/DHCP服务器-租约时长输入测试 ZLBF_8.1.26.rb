#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.26", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_lease_error  = "��Լʱ�䷶ΧΪ60-43200"
				@tc_lease_time1  = "0"
				@tc_lease_time2  = "59"
				@tc_lease_time3  = "60" #�߽�ֵ
				@tc_lease_time4  = "1800" #�ȼ�ֵ
				@tc_lease_time5  = "43200" #�߽�ֵ
				@tc_lease_time6  = "43201"
				@tc_netwait_time = 60
				@tc_sleep_time   = 1 #����������ͬλ����ʱ�޷����óɹ�
		end

		def process

				operate("1����½·����������������") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "�������ô�ʧ��!")
				}

				operate("2��������Լʱ������0�룬59�룬60�룬43200�룬43201�룬43300�룻") {
						puts "�޸�����Ϊ#{@tc_lease_time1}".encode("GBK")
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time1)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_lease_error, error_info, "δ��ʾ��Լʱ�䷶Χ")

						puts "�޸�����Ϊ#{@tc_lease_time2}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time2)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_lease_error, error_info, "δ��ʾ��Լʱ�䷶Χ")

						puts "�޸�����Ϊ#{@tc_lease_time3}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time3)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_netwait_time
						rs1 = @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value
						puts "Lease Time :#{rs1}".encode("GBK")
						assert_equal(@tc_lease_time3, rs1, "������Լʱ��Ϊ#{@tc_lease_time3}ʧ��")

						puts "�޸�����Ϊ#{@tc_lease_time4}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time4)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_netwait_time
						rs1 = @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value
						puts "Lease Time :#{rs1}".encode("GBK")
						assert_equal(@tc_lease_time4, rs1, "������Լʱ��Ϊ#{@tc_lease_time4}ʧ��")

						puts "�޸�����Ϊ#{@tc_lease_time5}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time5)
						@lan_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_netwait_time
						rs1 = @lan_iframe.text_field(id: @ts_tag_dhcp_lease).value
						puts "Lease Time :#{rs1}".encode("GBK")
						assert_equal(@tc_lease_time5, rs1, "������Լʱ��Ϊ#{@tc_lease_time5}ʧ��")

						puts "�޸�����Ϊ#{@tc_lease_time6}".encode("GBK")
						sleep @tc_sleep_time
						@lan_iframe.text_field(id: @ts_tag_dhcp_lease).set(@tc_lease_time6)
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_lease_error, error_info, "δ��ʾ��Լʱ�䷶Χ")
				}

				operate("3���������") {

				}


		end

		def clearup

		end

}
