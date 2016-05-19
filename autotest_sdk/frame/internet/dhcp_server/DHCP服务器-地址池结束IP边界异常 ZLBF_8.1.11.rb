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

				operate("1、登陆路由器进入内网设置；") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改DHCP地址范围:192.168.100.0~200；") {
						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						@endip         = tc_endip_field.value
						puts "当前结束IP地址为：#{@endip}".encode("GBK")
						puts "修改结束IP地址为：".encode("GBK")
						p new_endip = @endip.sub(/\.\d{1,3}$/, ".255")
						tc_endip_field.set(new_endip)
				}

				operate("3、点击保存；") {
						@lan_iframe.button(id: @ts_tag_sbm).click
						lanerr = @lan_iframe.span(id: @ts_tag_lanerr)
						assert(lanerr.exists?, "未提示IP地址格式有误")
						if lanerr.text.strip==@ts_lanip_err
								assert_equal(@ts_lanip_err, lanerr.text.strip, "IP地址池下边界超出范围提示信息错误")
								sleep @tc_net_time
						else
								assert(false, "IP地址池下边界超出范围提示信息错误")
								sleep @tc_lan_time
						end
				}
		end

		def clearup
				operate("1、恢复默认结束ip地址配置；") {
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
