#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.13", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_domain       = "zhiludomain.com"
				@tc_total_domain = "www.#{@tc_domain}"
				@browser_domain  = Watir::Browser.new(@ts_browser_ff, :profile => @ts_ff_profile)
		end

		def process

				operate("1、AP正常启动，设置为路由模式；") {
				}

				operate("2、进入到设备域名界面中，输入#{@tc_total_domain}，保存；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_domain(@tc_total_domain, @browser.url)
				}

				operate("3、在LAN侧PC中在浏览器中输入#{@tc_total_domain}，查看是否会跳转到AP登录界面；") {
						begin
								rs = login_default(@browser_domain, @tc_total_domain)
								assert(rs, "使用域名#{@tc_total_domain}登录路由器失败！")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end

				}

				operate("4、重启路由器，再输入#{@tc_total_domain}，查看能够跳转到AP登录界面。") {
						@browser.refresh
						@options_page.reboot
						begin
								@browser_domain.cookies.clear
								@browser_domain.refresh
								rs = login_default(@browser_domain, @tc_total_domain)
								assert(rs, "重启后使用域名登录路由器失败！")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end

				}


		end

		def clearup
				operate("关闭浏览器") {
						@browser_domain.close if @browser_domain.exists?
				}
		end

}
