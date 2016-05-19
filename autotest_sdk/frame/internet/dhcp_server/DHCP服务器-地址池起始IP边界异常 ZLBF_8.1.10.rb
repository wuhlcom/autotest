#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.10", "level" => "P2", "auto" => "n"}


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

				operate("2、更改DHCP地址范围:192.168.100.100~255；") {
						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						@startip         = tc_startip_field.value
						puts "当前起始IP地址为：#{@startip}".encode("GBK")
						puts "修改起始IP地址为：".encode("GBK")
						p new_startip = @startip.sub(/\.\d{1,3}$/, ".0")
						tc_startip_field.set(new_startip)
				}

				operate("3、点击保存；") {
						@lan_iframe.button(id: @ts_tag_sbm).click
						lanerr = @lan_iframe.span(id: @ts_tag_lanerr)
						assert(lanerr.exists?, "未提示IP地址格式有误")
						if lanerr.text.strip==@ts_lanip_err
								assert_equal(@ts_lanip_err, lanerr.text.strip, "IP地址池下限范围异常提示信息错误")
								sleep @tc_net_time
						else
								assert(false, "IP地址池下边界超出范围提示信息错误")
								sleep @tc_lan_time
						end
				}


		end

		def clearup
				operate("1 恢复为默认地址池范围") {
						unless @startip.nil?
								@browser.refresh
								@browser.span(id: @ts_tag_lan).click
								@lan_iframe      = @browser.iframe(src: @ts_tag_lan_src)
								tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
								re_startip       = tc_startip_field.value
								unless re_startip==@startip
										tc_startip_field.set(@startip)
										@lan_iframe.button(id: @ts_tag_sbm).click
										sleep @tc_lan_time
								end
						end

				}
		end


}
