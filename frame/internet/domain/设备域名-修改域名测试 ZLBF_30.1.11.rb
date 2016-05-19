#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.11", "level" => "P2", "auto" => "n"}

		def prepare
				@tc_domain        = "domaintest.com"
				@tc_total_domain  = "www.#{@tc_domain}"
				@tc_domain2       = "domaintest2.com"
				@tc_total_domain2 = "www.#{@tc_domain2}"
				@browser_domain   = Watir::Browser.new(@ts_browser_ff, :profile => @ts_ff_profile)
		end

		def process

				operate("1、AP正常启动，设置为路由模式；") {
				}

				operate("2、进入到设备域名界面中，输入#{@tc_total_domain}，保存，LAN侧PC输入#{@tc_total_domain} 是否能够正常登录；") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_domain(@tc_total_domain, @browser.url)
						begin
								rs = login_default(@browser_domain, @tc_total_domain)
								assert(rs, "使用域名#{@tc_total_domain}登录路由器失败！")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end
				}

				operate("3、再修改为#{@tc_total_domain2}， 保存，在LAN侧PC输入#{@tc_total_domain2}查看是否会跳转到AP登录界面。") {
						#设置域名
						p "设置域名为：#{@tc_total_domain2}".encode("GBK")
						@options_page.domain_name=@tc_total_domain2
						@options_page.save_domain
						begin
								@browser_domain.cookies.clear
								@browser_domain.refresh
								rs = login_default(@browser_domain, @tc_total_domain2)
								assert(rs, "使用域名#{@tc_total_domain2}登录路由器失败！")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end
				}


		end

		def clearup
				operate("1 关闭浏览器") {
						 @browser_domain.close if @browser_domain.exists?
				}
		end

}
