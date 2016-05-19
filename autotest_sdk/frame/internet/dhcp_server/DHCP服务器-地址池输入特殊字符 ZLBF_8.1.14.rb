#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.14", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_error_no_startip  = "������DHCP��ʼ��ַ"
				@tc_error_no_endip    = "������DHCP������ַ"
				@tc_error_not_same_seg= "DHCP��ַ�;�����IP����ͬһ����"
				@tc_error_ip_format   = "DHCP��ַ��ʽ����"
		end

		def process

				operate("1����½·����������������") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "�������ô�ʧ��!")
				}

				operate("2������DHCP��ַ�����������ַ���") {
						#��ȡĬ�ϵ���ʼ��ַ�ͽ�����ַ
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip  = tc_startip_field.value
						tc_endip_field   = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip    = tc_endip_field.value
						ip_arr           = current_startip.split(".")
						ip_arr_clone1    = ip_arr.clone
						ip_arr_clone2    = ip_arr.clone
						ip_arr_clone3    = ip_arr.clone
						puts "LAN DHCP Server pool start ip:#{current_startip}"
						puts "LAN DHCP Server pool end ip:#{current_endip}"

						puts "���������ַ�-".encode("GBK")
						ip_new1 = current_startip.sub(".", "-")
						puts "�޸���ʼIPΪ��#{ip_new1}".encode("GBK")
						#�޸���ʼ��ַ�ط�Χ
						tc_startip_field.set(ip_new1)
						tc_startip_field.set(ip_new1) unless tc_startip_field.value == ip_new1
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")

						#�޸Ľ�����ַ�ط�Χ
						puts "�޸Ľ���IPΪ��#{ip_new1}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new1)
						tc_endip_field.set(ip_new1) unless tc_endip_field.value == ip_new1
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")
						##############################################################################################################
						puts "�޸�IP��ַ��ʽx..x.x.x".encode("GBK")
						ip_new2 = ip_arr_clone2[0]+".."+ip_arr_clone2[1]+"."+ip_arr_clone2[2]+"."+ip_arr_clone2[3]
						puts "�޸���ʼIPΪ��#{ip_new2}".encode("GBK")
						#�޸���ʼ��ַ�ط�Χ
						tc_startip_field.set(ip_new2)
						tc_startip_field.set(ip_new2) unless tc_startip_field.value == ip_new2
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")

						#�޸Ľ�����ַ�ط�Χ
						puts "�޸Ľ���IPΪ��#{ip_new2}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new2)
						tc_endip_field.set(ip_new2) unless tc_endip_field.value == ip_new2
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")
						#################################################################################################################
						p "�޸�IP��ַ��Ϊx.x.x-x".encode("GBK")
						ip_new3 = ip_arr_clone3[0]+"."+ip_arr_clone3[1]+"."+ip_arr_clone3[2]+"-"+ip_arr_clone3[3]
						puts "�޸���ʼIPΪ��#{ip_new3}".encode("GBK")
						tc_startip_field.set(ip_new3)
						tc_startip_field.set(ip_new3) unless tc_startip_field.value == ip_new3
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")


						puts "�޸Ľ���IPΪ��#{ip_new3}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new3)
						tc_endip_field.set(ip_new3) unless tc_endip_field.value == ip_new3
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")
						#############################################################################
						p "�޸�IP��ַ��ʽΪx.x.x.@".encode("GBK")
						ip_new4 = ip_arr_clone3[0]+"."+ip_arr_clone3[1]+"."+ip_arr_clone3[2]+"-"+ip_arr_clone3[3]
						puts "�޸���ʼIPΪ��#{ip_new4}".encode("GBK")
						#�޸���ʼ��ַ�ط�Χ
						tc_startip_field.set(ip_new4)
						tc_startip_field.set(ip_new4) unless tc_startip_field.value == ip_new4
						tc_endip_field.set(current_endip)
						tc_endip_field.set(current_endip) unless tc_endip_field.value == current_endip
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")

						#�޸Ľ�����ַ�ط�Χ
						puts "�޸Ľ���IPΪ��#{ip_new4}".encode("GBK")
						tc_startip_field.set(current_startip)
						tc_startip_field.set(current_startip) unless tc_startip_field.value == current_startip
						tc_endip_field.set(ip_new4)
						tc_endip_field.set(ip_new4) unless tc_endip_field.value == ip_new4
						@lan_iframe.button(id: @ts_tag_sbm).click
						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_error_ip_format, error_info, "��ַ�����ô�����ʾ���ݲ���ȷ")
						##########################################################################################
				}

				operate("3���������") {

				}


		end

		def clearup

		end

}
