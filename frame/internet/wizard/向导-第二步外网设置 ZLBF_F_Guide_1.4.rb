#
# description:
#第二步是WAN设置
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.7", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1、PC登录到路由器，点击页面上设置向导按钮") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.guide
						router_mode_wz = @wan_page.rtmode_wz_element.visible?
						next_step      = @wan_page.rtmode_wz_map?
						assert(router_mode_wz, "未出现设置路由模式向导")
						assert(next_step, "未出现跳过按钮")
				}

				operate("2、进入到第二步外网设置，点击外网设置，是否能进入外网设置页面") {
						#点击路由模式向导的"跳过"
						@wan_page.rtmode_wz_map_element.area_element.click
						#查看向导是否跳到WAN设置
						wan_wz    = @wan_page.wanset_wz_element.visible?
						next_step = @wan_page.wanset_wz_map?
						assert(wan_wz, "未出现设置WAN设置向导")
						assert(next_step, "未出现跳过按钮")
						#打开WAN设置
						@wan_page.open_wan_page(@browser.url)
						rs = @browser.iframe(src: @ts_tag_netset_src).exists?
						assert(rs, "无法打开路由器WAN设置界面")
				}

		end

		def clearup

		end

}
