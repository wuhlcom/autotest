#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.11", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_net_time = 5
				@tc_lan_time = 30
		end

		def process

				operate("1����½·���������������ã�") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "�������ô�ʧ��!")
				}

				operate("2������DHCP��ַ��Χ:192.168.100.0~200��") {
						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						@endip         = tc_endip_field.value
						puts "��ǰ����IP��ַΪ��#{@endip}".encode("GBK")
						puts "�޸Ľ���IP��ַΪ��".encode("GBK")
						p new_endip = @endip.sub(/\.\d{1,3}$/, ".255")
						tc_endip_field.set(new_endip)
				}

				operate("3��������棻") {
						@lan_iframe.button(id: @ts_tag_sbm).click
						lanerr = @lan_iframe.span(id: @ts_tag_lanerr)
						assert(lanerr.exists?, "δ��ʾIP��ַ��ʽ����")
						if lanerr.text.strip==@ts_lanip_err
								assert_equal(@ts_lanip_err, lanerr.text.strip, "IP��ַ���±߽糬����Χ��ʾ��Ϣ����")
								sleep @tc_net_time
						else
								assert(false, "IP��ַ���±߽糬����Χ��ʾ��Ϣ����")
								sleep @tc_lan_time
						end
				}
		end

		def clearup
				operate("1���ָ�Ĭ�Ͻ���ip��ַ���ã�") {
						unless @endip.nil?
								@browser.refresh
								@browser.span(id: @ts_tag_lan).click
								@lan_iframe    = @browser.iframe(src: @ts_tag_lan_src)
								tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
								re_endip       = tc_endip_field.value
								unless @endip==re_endip
										tc_endip_field.set(@endip)
										@lan_iframe.button(id: @ts_tag_sbm).click
										sleep @tc_lan_time
								end
						end
				}

		end


}
