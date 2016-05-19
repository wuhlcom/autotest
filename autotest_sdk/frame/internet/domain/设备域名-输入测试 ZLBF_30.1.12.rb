#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.12", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_domain_error_tip = "域名只包括字母、数字、下划线、中划线"
				@tc_cn_domain        = "路由器"
				@tc_error_domain     = "Router@"
				@tc_error_domain1    = "zhi"
		end

		def process

				operate("1、AP正常启动，设置为路由模式；") {
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败！")
				}

				operate("2、进入到设备域名界面输入中文：中国人，查看是否能够保存；") {
						#点击系统设置
						@advance_iframe.link(id: @ts_tag_op_system).click
						#点击域名设置
						@advance_iframe.link(id: @ts_tag_domain).click
						#设置域名
						p "设置域名为：#{@tc_cn_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_cn_domain)
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip      = @advance_iframe.p(id: @ts_tag_domain_err)
						assert(error_tip.exists?,"未出现域名错误提示")
						error_tip_info = error_tip.text
						p "错误提示:#{error_tip}".encode("GBK")
						assert_equal(@tc_domain_error_tip,error_tip_info,"域名错误提示内容不正确!")
				}

				operate("3、在设备域名中输入特殊字符：~!@#$%^&*()，查看是否能够保存；") {
						p "设置域名为：#{@tc_error_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_error_domain)
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip      = @advance_iframe.p(id: @ts_tag_domain_err)
						assert(error_tip.exists?,"未出现域名错误提示")
						error_tip_info = error_tip.text
						p "错误提示:#{error_tip}".encode("GBK")
						assert_equal(@tc_domain_error_tip,error_tip_info,"域名错误提示内容不正确!")
				}

				operate("4、在设备域名中输入没有.cn/.com/.net查看是否能够保存。") {
						p "设置域名为：#{@tc_error_domain}".encode("GBK")
						@advance_iframe.text_field(name: @ts_tag_domain_field).set(@tc_error_domain1)
						@advance_iframe.button(id: @ts_tag_sbm).click
						error_tip      = @advance_iframe.p(id: @ts_tag_domain_err)
						assert(error_tip.exists?,"未出现域名错误提示")
						error_tip_info = error_tip.text
						p "错误提示:#{error_tip}".encode("GBK")
						assert_equal(@tc_domain_error_tip,error_tip_info,"域名错误提示内容不正确!")
				}


		end

		def clearup

		end

}
