#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.9", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_net_time  = 60
				@tc_pool_time = 5
		end

		def process

				operate("1、登陆路由器进入内网设置；") {
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
						assert(@lan_iframe.exists?, "内网设置打开失败!")
				}

				operate("2、更改DHCP地址范围:192.168.100.1~254；") {
						tc_serverip_field   = @lan_iframe.text_field(id: @ts_tag_lanip)
						@tc_serverip_before = tc_serverip_field.value
						@tc_server_change   = false
						if @tc_serverip_before.split(".").last == "1"
								new_serverip = @tc_serverip_before.succ
								puts "修改DHCP服务器地址为：#{new_serverip}".encode("GBK")
								tc_serverip_field = @lan_iframe.text_field(id: @ts_tag_lanip).set(new_serverip)
								@tc_server_change = true
						end

						tc_startip_field = @lan_iframe.text_field(id: @ts_tag_lanstart)
						@startip         = tc_startip_field.value
						@new_startip     = @startip.sub(/\.\d{1,3}$/, ".1")
						puts "当前起始IP为：#{@startip}".encode("GBK")
						puts "修改起始IP为：#{@new_startip}".encode("GBK")
						#修改起始地址池范围
						tc_startip_field.set(@new_startip)

						tc_endip_field = @lan_iframe.text_field(id: @ts_tag_lanend)
						@endip         = tc_endip_field.value
						#修改结束地址池范围
						@new_endip     = @endip.sub(/\.\d{1,3}$/, ".254")
						puts "当前结束IP为：#{@endip}".encode("GBK")
						puts "修改结束IP为：#{@new_endip}".encode("GBK")
						tc_endip_field.set(@new_endip)
				}

				operate("3、点击保存；") {
						@lan_iframe.button(id: @ts_tag_sbm).click
						if @tc_server_change
								sleep @tc_net_time
								login_no_default_ip(@browser)
						else
								sleep @tc_pool_time
								@browser.refresh
						end
						@browser.span(id: @ts_tag_lan).click
						@lan_iframe       = @browser.iframe(src: @ts_tag_lan_src)
						tc_serverip_field = @lan_iframe.text_field(id: @ts_tag_lanip)
						@tc_serverip      = tc_serverip_field.value
						tc_startip_field  = @lan_iframe.text_field(id: @ts_tag_lanstart)
						re_startip        = tc_startip_field.value
						tc_endip_field    = @lan_iframe.text_field(id: @ts_tag_lanend)
						re_endip          = tc_endip_field.value
						assert_equal(@new_startip, re_startip, "IP地址池起始边界设置失败!")
						assert_equal(@new_endip, re_endip, "IP地址池结束边界设置失败!")
				}


		end

		def clearup

				operate("恢复默认配置") {
						unless @tc_serverip == @ts_default_ip
								unless @lan_iframe.nil? && @lan_iframe.exists?
										login_recover(@browser,@ts_default_ip)
										@browser.span(id: @ts_tag_lan).click
										@lan_iframe= @browser.iframe(src: @ts_tag_lan_src)
								end
								@lan_iframe.text_field(id: @ts_tag_lanip).set(@ts_default_ip)
								@lan_iframe.text_field(id: @ts_tag_lanstart).set(@startip)
								@lan_iframe.text_field(id: @ts_tag_lanend).set(@endip)
								@lan_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}
		end

}
