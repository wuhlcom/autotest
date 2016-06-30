#
# description:
# author:wuhongliang
# date:2015-10-%qos 17:43:16
# modify:
#
testcase {
		attr = {"id" => "ZLBF_8.1.10", "level" => "P2", "auto" => "n"}


		def prepare
				@tc_land_starterr = "0"
				@tc_lan_time      = 30
		end

		def process

				operate("1、登陆路由器进入内网设置；") {
						@lan_page = RouterPageObject::LanPage.new(@browser)
						@lan_page.open_lan_page(@browser.url)
						@tc_lan_start_pre = @lan_page.lan_startip_pre
				}

				operate("2、更改DHCP地址范围:192.168.100.0~200；") {
						@tc_lan_start     = @lan_page.lan_startip
						@tc_lan_startip   = @tc_lan_start_pre+@tc_land_starterr
						puts "修改地址池起始地址为 #{@tc_lan_startip}".to_gbk
						@lan_page.lan_startip_set(@tc_land_starterr)
				}

				operate("3、点击保存；") {
						@lan_page.save_lanset
						puts "ERROR TIP:#{@lan_page.lan_error}".to_gbk
						if @lan_page.lan_error==@ts_lanip_err
								assert_equal(@ts_lanip_err, @lan_page.lan_error.strip, "IP地址池上边界超出范围提示信息错误")
						else
								sleep @tc_lan_time
								assert(false, "IP地址池上边界超出范围也能保存")
						end

				}


		end

		def clearup
				operate("1 恢复默认起始地址范围") {
						unless @tc_lan_start.nil?
								@browser.refresh
								@lan_page.open_lan_page(@browser.url)
								tc_lan_start = @lan_page.lan_startip
								unless tc_lan_start == @tc_lan_start
										@lan_page.lan_startip_set(@tc_lan_start)
										@lan_page.btn_save_lanset
								end
						end
				}
		end


}
