#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.12", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1、PC登录到路由器，点击页面上设置向导按钮") {
						@wifi_page = RouterPageObject::WIFIPage.new(@browser)
						@wifi_page.guide
						router_mode_wz = @wifi_page.rtmode_wz_element.visible?
						next_step      = @wifi_page.rtmode_wz_map?
						assert(router_mode_wz, "未出现设置路由模式向导")
						assert(next_step, "未出现跳过按钮")

						#点击路由模式向导的"跳过"
						@wifi_page.rtmode_wz_map_element.area_element.click
						#查看向导是否跳到WAN设置
						wan_wz    = @wifi_page.wanset_wz_element.visible?
						next_step = @wifi_page.wanset_wz_map?
						assert(wan_wz, "未出现设置WAN设置向导")
						assert(next_step, "未出现跳过按钮")

						#点击WAN设置向导的"跳过"
						@wifi_page.wanset_wz_map_element.area_element.click
						#查看向导是否跳到LAN设置
						lan_wz    = @wifi_page.lanset_wz_element.visible?
						next_step = @wifi_page.lanset_wz_map?
						assert(lan_wz, "未出现设置LAN设置向导")
						assert(next_step, "未出现跳过按钮")

						#点击LAN设置向导的"跳过"
						@wifi_page.lanset_wz_map_element.area_element.click
						#查看向导是否跳到WIFI设置
						lan_wz    = @wifi_page.wifiset_wz_element.visible?
						next_step = @wifi_page.wifiset_wz_map?
						assert(lan_wz, "未出现设置WIFI设置向导")
						assert(next_step, "未出现跳过按钮")
				}

				operate("2、进入到第四步WIFI设置，点击跳过，是否跳到设置完成") {
						#点击WIFI设置向导的"跳过"
						@wifi_page.wifiset_wz_map_element.area_element.click
						#查看向导是否跳到WIFI设置
						wifiset_wz = @wifi_page.wz_finish_element.visible?
						next_step  = @wifi_page.wz_finish_map?
						assert(wifiset_wz, "未出现设置完成向导")
						assert(next_step, "未出现开始使用按钮")
				}


		end

		def clearup

		end

}
