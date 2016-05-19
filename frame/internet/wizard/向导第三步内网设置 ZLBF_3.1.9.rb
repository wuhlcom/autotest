#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.9", "level" => "P1", "auto" => "n"}

	def prepare

	end

	def process

		operate("1、PC登录到路由器，点击页面上设置向导按钮") {
				@lan_page = RouterPageObject::LanPage.new(@browser)
				@lan_page.guide
				router_mode_wz = @lan_page.rtmode_wz_element.visible?
				next_step      = @lan_page.rtmode_wz_map?
				assert(router_mode_wz, "未出现设置路由模式向导")
				assert(next_step, "未出现跳过按钮")

				#点击路由模式向导的"跳过"
				@lan_page.rtmode_wz_map_element.area_element.click
				#查看向导是否跳到WAN设置
				wan_wz    = @lan_page.wanset_wz_element.visible?
				next_step = @lan_page.wanset_wz_map?
				assert(wan_wz, "未出现设置WAN设置向导")
				assert(next_step, "未出现跳过按钮")
		}

		operate("2、进入到第三步内网设置，点击查看状态，是否能进入查看状态页面") {
				#点击WAN设置向导的"跳过"
				@lan_page.wanset_wz_map_element.area_element.click
				#查看向导是否跳到LAN设置
				lan_wz    = @lan_page.lanset_wz_element.visible?
				next_step = @lan_page.lanset_wz_map?
				assert(lan_wz, "未出现设置LAN设置向导")
				assert(next_step, "未出现跳过按钮")

				@lan_page.open_lan_page(@browser.url)
				rs = @browser.iframe(src: @ts_tag_lan_src).exists?
				assert(rs, "无法打开路由器LAN设置界面")
		}
			
	end

	def clearup

	end

}
