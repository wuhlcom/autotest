#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_3.1.5", "level" => "P1", "auto" => "n"}

	def prepare
		@tc_wait_time       = 3
		@tc_tag_setup_guide = "setup_guide"
		@tc_tag_net_guide   = "images/step1.png"
		@tc_tag_map         = "Map"
	end

	def process

		operate("1、PC登录到路由器，点击页面上设置向导按钮") {
			@browser.link(id: @tc_tag_setup_guide).click
			assert(@browser.image(src: @tc_tag_net_guide).exists?, "向导打开失败")
			assert(@browser.map(id: @tc_tag_map).exists?, "向导中没有下一步按钮")
		}

		operate("2、进入到第一步外网设置，点击外网设置，是否能进入外网设置页面") {
			@browser.span(id: @ts_tag_netset).click
			Watir::Wait.until(@tc_wait_time, "打开外网设置失败！") {
				@browser.iframe(src: @ts_tag_netset_src).present?
			}
		}

		operate("3、进行外网配置后，点击确定，是否配置成功") {
			#这里不做配置只打开外网设置，然后关闭
			if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
				@browser.execute_script(@ts_close_div)
			end
			Watir::Wait.while(@tc_wait_time, "关闭外网设置失败！") {
				@browser.iframe(src: @ts_tag_netset_src).present?
			}
		}

		operate("4、配置成功后，是否返回到向导页面") {
			#配置成功后是不会返回到向导的
		}


	end

	def clearup

	end

}
