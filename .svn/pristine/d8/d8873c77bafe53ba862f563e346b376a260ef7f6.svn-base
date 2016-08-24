#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.13", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_domain       = "domaintest.com"
				@tc_total_domain = "www.#{@tc_domain}"
				@tc_save_time    = 10
				@browser_domain  = Watir::Browser.new(@ts_browser_ff, :profile => @ts_ff_profile)
				@tc_reboot_time  = 150
		end

		def process

				operate("1、AP正常启动，设置为路由模式；") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败！")
				}

				operate("2、进入到设备域名界面中，输入zhilu.com，保存；") {
						#点击系统设置
						@advance_iframe.link(id: @ts_tag_op_system).click
						#点击域名设置
						@advance_iframe.link(id: @ts_tag_domain).click
						#设置域名
						p "设置域名为：#{@tc_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_domain)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_save_time
				}

				operate("3、在LAN侧PC中在浏览器中输入#{@tc_domain}，查看是否会跳转到AP登录界面；") {
						begin
								rs = login_default(@browser_domain, @tc_total_domain)
								assert(rs, "使用域名登录路由器失败！")
						rescue => ex
								p ex.message.to_s
								@browser_domain.close if @browser_domain.exists?
						end

				}

				operate("4、重启路由器，再输入#{@tc_domain}，查看能够跳转到AP登录界面。") {
						@advance_iframe.link(id: @ts_tag_op_reboot_tab).click
						@advance_iframe.button(id: @ts_tag_op_reboot).click
						@advance_iframe.button(class_name: @ts_tag_reboot_confirm).click
						sleep @tc_reboot_time
						begin
								@browser_domain.cookies.clear
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
