#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.11", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time        = 3
		@tc_tag_setup_guide  = "setup_guide"
		@tc_tag_net_guide    = "images/step1.png"
		@tc_tag_lan_guide    = "images/step2.png"
		@tc_tag_status_guide = "images/step3.png"
		@tc_tag_use_guide    = "images/step4.png"
		@tc_tag_map          = "Map"
		@tc_tag_map2         = "Map2"
		@tc_tag_map3         = "Map3"
		@tc_tag_map4         = "Map4"
	end

	def process

		operate("1、PC登录到路由器，点击页面上设置向导按钮") {
			@browser.link(id: @tc_tag_setup_guide).click
			assert(@browser.image(src: @tc_tag_net_guide).exists?, "向导打开失败")
			assert(@browser.map(id: @tc_tag_map).exists?, "向导中没有下一步按钮")
		}

		operate("2、进入到第四步设置完成，点击开始使用，是否返回到首页页面") {
			#点击外网设置的"跳过"
			@browser.map(id: @tc_tag_map).area.click
			assert(@browser.image(src: @tc_tag_lan_guide).exists?, "向导跳转LAN设置失败")
			assert(@browser.map(id: @tc_tag_map2).exists?, "向导中LAN设置下一步按钮未出现")

			#点击内网设置的"跳过"
			@browser.map(id: @tc_tag_map2).area.click
			assert(@browser.image(src: @tc_tag_status_guide).exists?, "向导跳转LAN设置失败")
			assert(@browser.map(id: @tc_tag_map3).exists?, "向导中LAN设置下一步按钮未出现")

			#点击状态界面的"跳过"
			@browser.map(id: @tc_tag_map3).area.click
			assert(@browser.image(src: @tc_tag_use_guide).exists?, "向导跳转LAN设置失败")
			assert(@browser.map(id: @tc_tag_map4).exists?, "向导中LAN设置下一步按钮未出现")

			#点击开始使用
			@browser.map(id: @tc_tag_map4).area.click
			Watir::Wait.while(@tc_wait_time, "打开外网设置失败！") {
				@browser.image(src: @tc_tag_use_guide).present?
				@browser.map(id: @tc_tag_map4).present?
			}
		}


	end

	def clearup

	end

}
