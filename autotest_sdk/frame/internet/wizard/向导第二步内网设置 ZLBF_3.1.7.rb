#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.7", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time       = 3
		@tc_tag_setup_guide = "setup_guide"
		@tc_tag_net_guide   = "images/step1.png"
		@tc_tag_lan_guide   = "images/step2.png"
		@tc_tag_map         = "Map"
		@tc_tag_map2        = "Map2"
	end

	def process

		operate("1、PC登录到路由器，点击页面上设置向导按钮") {
			@browser.link(id: @tc_tag_setup_guide).click
			assert(@browser.image(src: @tc_tag_net_guide).exists?, "向导打开失败")
			assert(@browser.map(id: @tc_tag_map).exists?, "向导中没有下一步按钮")

		}

		operate("2、进入到第二步内网设置，点击内网设置，是否能进入内网设置页面") {
			#点击外网设置的"跳过"
			@browser.map(id: @tc_tag_map).area.click
			assert(@browser.image(src: @tc_tag_lan_guide).exists?, "向导跳转LAN设置失败")
			assert(@browser.map(id: @tc_tag_map2).exists?, "向导中LAN设置下一步按钮未出现")
		}

		operate("3、进行内网配置后，点击确定，是否配置成功") {
			@browser.span(id: @ts_tag_lan).click
			Watir::Wait.until(@tc_wait_time, "打开外网设置失败！") {
				@browser.iframe(src: @ts_tag_lan_src).present?
			}
		}

		operate("4、配置成功后，是否返回到向导页面") {

		}


	end

	def clearup

	end

}
