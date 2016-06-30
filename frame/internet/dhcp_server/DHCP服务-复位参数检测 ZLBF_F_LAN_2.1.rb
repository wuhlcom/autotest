#
# description:
# author:wuhongliang
# date:2015-10-16 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.24", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_default_ip    = "192.168.100.1"
				@tc_default_start = "100"
				@tc_default_end   = "200"
				@tc_lan_ip_new    = "192.168.30.1"
				@tc_lan_start_new = "50"
				@tc_lan_end_new   = "100"
				@tc_lan_time      = 70
		end

		def process

				operate("1、进入LAN设置页面；") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
				}

				operate("2、更改LAN IP与子网掩码，更改地址池范围") {
						@lan_page.lan_ip = @tc_lan_ip_new
						@lan_page.lan_startip_set @tc_lan_start_new
						@lan_page.lan_endip_set @tc_lan_end_new
						@lan_page.btn_save_lanset
						# puts "sleep #{@tc_lan_time} seconds..."
						# sleep @tc_lan_time
						puts "修改LAN IP后返回到登录界面".to_gbk
						assert(@lan_page.username?, "修改LAN IP后弹出新地址界面")
						#重新登录
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						# login(@browser, @tc_lan_ip_new)
						#检查是否配置成功
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_lan_ip_new, tc_lan_ip, "修改LAN IP失败")
						assert_equal(@tc_lan_start_new, tc_lan_start, "修改LAN起始地址失败")
						assert_equal(@tc_lan_end_new, tc_lan_end, "修改LAN结束地址失败")
				}

				operate("3、恢复DUT为出厂默认状态，查看LAN设置页面的参数是否被复位成默认状态。") {
						@advance_page = RouterPageObject::OptionsPage.new(@browser)
						@advance_page.recover_factory(@browser.url)
						sleep @tc_lan_time
						assert(@advance_page.username?, "恢复出厂值后返回到登录界面")
						#重新登录
						rs_login = login_no_default_ip(@browser) #重新登录
						assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
						#查看是否恢复成功
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						assert_equal(@tc_default_ip, tc_lan_ip, "修改LAN IP失败")
						assert_equal(@tc_default_start, tc_lan_start, "修改LAN起始地址失败")
						assert_equal(@tc_default_end, tc_lan_end, "修改LAN结束地址失败")
				}
		end

		def clearup

				operate("1 恢复LAN设置为默认配置") {
						@browser.refresh
						@lan_page = RouterPageObject::LanPage.new(@browser)
						if @lan_page.username?
								rs_login = login_no_default_ip(@browser) #重新登录
								p rs_login[:flag]
								p rs_login[:message]
						end
						@lan_page.open_lan_page(@browser.url)
						tc_lan_ip    = @lan_page.lan_ip
						tc_lan_start = @lan_page.lan_startip
						tc_lan_end   = @lan_page.lan_endip
						flag         = false

						unless tc_lan_ip == @tc_default_ip
								@lan_page.lan_ip = @tc_default_ip
								flag             = true
						end

						unless tc_lan_start == @tc_default_start
								@lan_page.lan_startip_set @tc_default_start
								flag = true
						end

						unless tc_lan_end == @tc_default_end
								@lan_page.lan_endip_set @tc_default_end
								flag = true
						end
						if flag
								@lan_page.btn_save_lanset
						end
				}
		end

}
