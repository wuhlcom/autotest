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
				@tc_bw1       =" 10000"
				@tc_bw2       ="100 00"
				@tc_bw3       ="10000 "
				@tc_bw4       =""
				@tc_bw_error1 ="只允许输入正数"
				@tc_bw_error2 ="请填写申请的宽带大小！"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框") {
						####未配置宽带控制时下载统计
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2、设置申请带宽开头有空格' 10000',保存") {
						puts "设置总带宽为#{@tc_bw1}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")
				}

				operate("3、设置申请带宽中间有空格'100 00',保存") {
						puts "设置总带宽为#{@tc_bw2}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw2)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")
				}

				operate("4、设置申请带宽中间有空格'100 00',保存") {
						puts "设置总带宽为#{@tc_bw3}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw3)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")
				}

				operate("5 、 设置申请带宽为空, 即不输入任何值 ， 保存") {
						puts "设置总带宽为空".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw4)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error2, error_msg, "未提示保存失败")
				}

		end

		def clearup
				operate("1 恢复默认带宽设置") {
						if @options_page.total_bw?
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						else
								@options_page = RouterPageObject::OptionsPage.new(@browser)
								@options_page.select_traffic_ctl(@browser.url)
								@options_page.unselect_traffic_sw
								@options_page.save_traffic(10)
						end
				}
		end

}
