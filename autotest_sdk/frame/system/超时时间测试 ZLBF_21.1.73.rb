#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_21.1.73", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_login_timeout = 20*60
		end

		def process

				operate("1、登陆DUT，进入密码修改页面；") {
						rs_login = login_recover(@browser, @ts_default_ip)
						assert(rs_login, "路由器登录失败！")
				}

				operate("2、超时为15分钟，检查不操作时间超过15分钟，是否需要重新登录认证；") {
						#超时时间为5分钟
						puts "sleep #{@tc_login_timeout-60} seconds login router timeout ..."
						sleep @tc_login_timeout-60
						Watir::Wait.until(65,"等待路由器登录超时失败".encode("GBK")){
								@browser.text_field(name:@ts_tag_usr).exists?
						}
				}

		end

		def clearup

		end

}
