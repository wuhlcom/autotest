#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.12", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_domain_error_tip = "请输入正确格式的url,域名只应该由字母、数字和 '-' 组成,如：www.abc-123.com"
				@tc_domain_error     = "请输入域名"
				@tc_empty_domain     = ""
				@tc_space_domain     = " "
				@tc_cn_domain        = "路由器"
				@tc_error_domain     = "Router@"
				@tc_error_domain1    = "zhi"
		end

		def process

				operate("1、AP正常启动，设置为路由模式；") {
						#设置域名
						p "设置域名为空".encode("GBK")
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.set_domain(@tc_empty_domain, @browser.url)
						error_tip_info = @options_page.domain_error
						p "错误提示:#{error_tip_info}".encode("GBK")
						assert_equal(@tc_domain_error, error_tip_info, "域名错误提示内容不正确!")
						p "设置域名为空格".encode("GBK")
						@options_page.domain_name=@tc_space_domain
						@options_page.save_domain
						error_tip_info = @options_page.domain_error
						p "错误提示:#{error_tip_info}".encode("GBK")
						assert_equal(@tc_domain_error_tip, error_tip_info, "域名错误提示内容不正确!")
				}

				operate("2、进入到设备域名界面输入中文：中国人，查看是否能够保存；") {
						#设置域名
						p "设置域名为：#{@tc_cn_domain}".encode("GBK")
						@options_page.domain_name=@tc_cn_domain
						@options_page.save_domain
						error_tip_info = @options_page.domain_error
						p "错误提示:#{error_tip_info}".encode("GBK")
						assert_equal(@tc_domain_error_tip, error_tip_info, "域名错误提示内容不正确!")
				}

				operate("3、在设备域名中输入特殊字符：~!@#$%^&*()，查看是否能够保存；") {
						p "设置域名为：#{@tc_error_domain}".encode("GBK")
						@options_page.domain_name=@tc_error_domain
						@options_page.save_domain
						error_tip_info = @options_page.domain_error
						p "错误提示:#{error_tip_info}".encode("GBK")
						assert_equal(@tc_domain_error_tip, error_tip_info, "域名错误提示内容不正确!")
				}

				operate("4、在设备域名中输入没有.cn/.com/.net查看是否能够保存。") {
						p "设置域名为：#{@tc_error_domain1}".encode("GBK")
						@options_page.domain_name=@tc_error_domain1
						@options_page.save_domain
						error_tip_info = @options_page.domain_error
						p "错误提示:#{error_tip_info}".encode("GBK")
						assert_equal(@tc_domain_error_tip, error_tip_info, "域名错误提示内容不正确!")
				}


		end

		def clearup

		end

}
