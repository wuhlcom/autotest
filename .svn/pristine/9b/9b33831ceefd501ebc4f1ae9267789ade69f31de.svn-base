#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.8", "level" => "P1", "auto" => "n"}

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

				operate("2、进入到第二步外网设置，点击跳过，是否跳到第三步") {
						#点击路由模式向导的"跳过"
						@wan_page.rtmode_wz_map_element.area_element.click
						#查看向导是否跳到WAN设置
						wan_wz    = @wan_page.wanset_wz_element.visible?
						next_step = @wan_page.wanset_wz_map?
						assert(wan_wz, "未出现设置WAN设置向导")
						assert(next_step, "未出现跳过按钮")

						#点击WAN设置向导的"跳过"
						@wan_page.wanset_wz_map_element.area_element.click
						#查看向导是否跳到LAN设置
						lan_wz    = @wan_page.lanset_wz_element.visible?
						next_step = @wan_page.lanset_wz_map?
						assert(lan_wz, "未出现设置LAN设置向导")
						assert(next_step, "未出现跳过按钮")
				}


		end

		def clearup

		end

}
