#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.13", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_lan_time = 35
		end

		def process

				operate("1、登陆路由器进入内网设置") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2、更改DHCP地址池输入中文和英文；") {
						@tc_lan_start_pre = @lan_page.lan_startip_pre
						@tc_lan_start     = @lan_page.lan_startip
						@tc_lan_startip   = @tc_lan_start_pre+@tc_lan_start

						@tc_lan_end_pre = @lan_page.lan_endip_pre
						@tc_lan_end     = @lan_page.lan_endip
						@tc_lan_endip   = @tc_lan_end_pre+@tc_lan_end

						puts "Current LAN DHCP Server pool start ip:#{@tc_lan_startip}"
						puts "Current LAN DHCP Server pool end ip:#{@tc_lan_endip}"

						puts "地址输入中文".encode("GBK")
						address_ch = "地址"
						puts "修改起始IP为：'#{address_ch}'".encode("GBK")
						@lan_page.lan_startip_set(address_ch)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池起始地址输入中文提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址输入中文也能保存")
						end

						puts "修改结束IP为：'#{address_ch}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(address_ch)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池结束地址输入中文提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址输入中文也能保存")
						end

						puts "IP地址输入英文".encode("GBK")
						address_en = "IP"
						puts "修改起始IP为：'#{address_en}'".encode("GBK")
						@lan_page.lan_startip_set(address_en)
						@lan_page.lan_endip_set(@tc_lan_end)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池起始地址输入英文提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池起始地址输入中文也能保存")
						end

						puts "修改结束IP为：'#{address_en}'".encode("GBK")
						@lan_page.lan_startip_set(@tc_lan_start)
						@lan_page.lan_endip_set(address_en)
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "地址池结束地址输入英文提示错误")
						else
								sleep @tc_lan_time
								assert(false, "地址池结束地址输入英文也能保存")
						end
				}

				operate("3、点击保存") {
						#第二步已经实现
				}


		end

		def clearup

				operate("1 恢复默认起始地址范围") {
						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						flag         = false
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
		end

}
