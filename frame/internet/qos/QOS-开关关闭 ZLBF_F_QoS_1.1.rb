#
# description:
# 测试默认状态下流量
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.1", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_bw_error = "请勾选IP带宽控制，并请填写您申请的带宽大小"
				@tc_total_bw = "10000"

		end

		def process

				operate("1、进入DUT流量管理页面，去勾选“开启IP带宽控制”选项框") {
						####未配置宽带控制时下载统计
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2、设置总带宽") {
						@options_page.unselect_traffic_sw #关闭带宽控制
						@options_page.set_total_bw(@tc_total_bw)
				}

				operate("	3、保存") {
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error, error_msg, "未提示保存失败")
				}

		end

		def clearup

		end

}
