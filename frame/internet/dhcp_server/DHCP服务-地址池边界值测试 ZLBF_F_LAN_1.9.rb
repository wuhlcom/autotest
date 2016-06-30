#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.9", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_lan_time   = 35
				@tc_wait_time  = 5
				@tc_static_ip  = @ts_default_ip.sub(/\.\d+$/, '.123')
				@tc_static_args= {nicname: @ts_nicname, source: "static", ip: "#{@tc_static_ip}", mask: "255.255.255.0"}
				@tc_dhcp_args  = {nicname: @ts_nicname, source: "dhcp"}
				@tc_ip_min     = "1"
				@tc_ip_max     = "254"
		end

		def process

				operate("1、登陆路由器进入内网设置；") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2、更改DHCP地址范围:192.168.100.1~254；") {
						#将网卡设置为静态IP
						netsh_if_ip_setip(@tc_static_args)
						sleep @tc_wait_time
						#获取当前的起始和结束范围
						tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_ip       = @lan_page.lan_ip
						puts "当前LAN IP为：#{@tc_lan_ip}".encode("GBK")

						@tc_lan_start  = @lan_page.lan_startip
						@tc_lan_end    = @lan_page.lan_endip
						tc_lan_startip = tc_lan_start_pre+@tc_lan_start
						tc_lan_endip   = tc_lan_start_pre+@tc_lan_end
						puts "当前起始IP值：#{tc_lan_startip}".encode("GBK")
						puts "当前结束IP值：#{tc_lan_endip}".encode("GBK")

						tc_lan_ip_min = tc_lan_start_pre+@tc_ip_min
						tc_lan_ip_max = tc_lan_start_pre+@tc_ip_max
						puts "修改起始IP为最小边界值：#{tc_lan_ip_min}".encode("GBK")
						puts "修改结束IP为最小边界值：#{tc_lan_ip_min}".encode("GBK")
						#当lan IP为x.x.x.1时修改lan ip
						lan_change=false
						if @tc_lan_ip.split(".").last=="1"
								puts "修改LAN IP为：#{@tc_lan_ip.succ}".encode("GBK")
								@lan_page.lan_ip=@tc_lan_ip.succ
								lan_change      =true
						end
						@lan_page.lan_startip= @tc_ip_min
						@lan_page.lan_endip  = @tc_ip_min
						@lan_page.btn_save_lanset
						if lan_change
								rs_login = login_no_default_ip(@browser) #重新登录
								assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						end
						@browser.refresh
						@lan_page.open_lan_page(@browser.url)
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_ip_min, tc_lan_start, "起始IP输入最小边界值失败")
						assert_equal(@tc_ip_min, tc_lan_end, "结束IP输入最小边界值失败")

						puts "修改起始IP为最大边界值：#{tc_lan_ip_max}".encode("GBK")
						puts "修改结束IP为最大边界值：#{tc_lan_ip_max}".encode("GBK")
						@lan_page.lan_startip= @tc_ip_max
						@lan_page.lan_endip  = @tc_ip_max
						@lan_page.btn_save_lanset
						@browser.refresh
						@lan_page.open_lan_page(@browser.url)
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_ip_max, tc_lan_start, "起始IP输入最大边界值失败")
						assert_equal(@tc_ip_max, tc_lan_end, "结束IP输入最大边界值失败")

						puts "修改起始IP为最小边界值：#{tc_lan_ip_min}".encode("GBK")
						puts "修改结束IP为最大边界值：#{tc_lan_ip_max}".encode("GBK")
						@lan_page.lan_startip= @tc_ip_min
						@lan_page.lan_endip  = @tc_ip_min
						@lan_page.btn_save_lanset
						@browser.refresh
						@lan_page.open_lan_page(@browser.url)
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_ip_min, tc_lan_start, "起始IP输入最小边界值失败")
						assert_equal(@tc_ip_min, tc_lan_end, "结束IP输入最大边界值失败")
				}

				operate("3、点击保存；") {

				}


		end

		def clearup

				operate("1 恢复默认地址池址范围") {
						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						flag         = false

						#恢复默认起始地址
						unless (!@tc_lan_ip.nil? && tc_lan_ip == @tc_lan_ip)
								puts "恢复默认LAN地址".to_gbk
								@lan_page.lan_ip_set(@tc_lan_ip)
								flag= true
						end

						#恢复默认起始地址
						unless (!@tc_lan_start.nil? && tc_lan_start == @tc_lan_start)
								puts "恢复默认起始地址".to_gbk
								@lan_page.lan_startip_set(@tc_lan_start)
								flag= true
						end

						#恢复默认结束地址
						unless (!@tc_lan_end.nil? && tc_lan_end == @tc_lan_end)
								puts "恢复默认结束地址".to_gbk
								@lan_page.lan_endip_set(@tc_lan_end)
								flag= true
						end

						if flag
								@lan_page.btn_save_lanset
						end
				}

				operate("2 恢复网卡状态") {
						netsh_if_ip_setip(@tc_dhcp_args)
				}
		end

}
