#
# description:
# openWRT第一步是路由模式选择
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_3.1.5", "level" => "P1", "auto" => "n"}

		def prepare

		end

		def process

				operate("1、PC登录到路由器，点击页面上设置向导按钮") {
						@mode_page = RouterPageObject::ModePage.new(@browser)
						@mode_page.guide
						router_mode_wz = @mode_page.rtmode_wz_element.visible?
						next_step      = @mode_page.rtmode_wz_map?
						assert(router_mode_wz, "未出现设置路由模式向导")
						assert(next_step, "未出现跳过按钮")
				}

				operate("2、进入到第一步路由器模式设置，点击路由器模式，是否能进入路由器模式设置页面") {
						puts "打开路由器模式设置".to_gbk
						@mode_page.open_mode_page(@browser.url)
						rs = @browser.iframe(src: @ts_tag_router_mode).exists?
						assert(rs, "无法打开路由器模式设置界面")
				}

		end

		def clearup

		end

}
