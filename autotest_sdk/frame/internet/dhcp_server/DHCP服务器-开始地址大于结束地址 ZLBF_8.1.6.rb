#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.6", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_err_info = "������ַӦ���ڿ�ʼ��ַ"
		end

		def process

				operate("1����½·���������������ã�") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "�������ô�ʧ��!")
				}

				operate("2������DHCP��ַ��Χ��192.168.100.100~10��") {
						tc_lan_field     = @lan_iframe.text_field(id: @ts_tag_lanip)
						@current_lan_ip  = tc_lan_field.value
						new_start_ip     = @current_lan_ip.sub(/\.\d{1,3}$/, ".100")
						new_end_ip       = @current_lan_ip.sub(/\.\d{1,3}$/, ".50")

						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						current_startip = tc_startip_field.value
						puts "��ǰLAN��ʼ��ַ��IPΪ#{current_startip}".encode("GBK")
						puts "�޸�Ϊ#{new_start_ip}".encode("GBK")
						tc_startip_field.set(new_start_ip)

						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						current_endip = tc_endip_field.value
						puts "��ǰLAN������ַ��IPΪ#{current_endip}".encode("GBK")
						puts "�޸�Ϊ#{new_end_ip}".encode("GBK")
						tc_endip_field.set(new_end_ip)

						@lan_iframe.button(id: @ts_tag_sbm).click

						error_tip = @lan_iframe.span(id: @ts_tag_lanerr).exists?
						assert(error_tip, "δ��ʾ���ô���")
						error_info = @lan_iframe.span(id: @ts_tag_lanerr).text
						puts "ERROR TIP:#{error_info}".encode("GBK")
						assert_equal(@tc_err_info, error_info, "������ʾ���ݲ���ȷ")
				}

				operate("3��������棻") {

				}


		end

		def clearup

		end

}
