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
				# 				1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框
				# 				2、设置申请带宽为特殊符号"`~!@#$%^&*()_+{}:"|>?<-=[];'\/.,",保存
				# 3、设置申请带宽为字母如"10abzjb",保存
				# 4、设置申请带宽为中文"带宽"，保存
				@tc_bw1       ="1000&"
				@tc_bw2       ="#2500"
				@tc_bw3       ="1000-0"
				@tc_bw4       ="1000bf0"
				@tc_bw5       ="1020带宽"
				@tc_bw_error1 ="只允许输入正数"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框") {
						####未配置宽带控制时下载统计
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2、设置申请带宽为特殊符号`~!@#$%^&*()_+{}:\"|>?<-=[];\'\/.,,保存") {
						puts "设置总带宽为#{@tc_bw1}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")

						puts "设置总带宽为#{@tc_bw2}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")

						puts "设置总带宽为#{@tc_bw3}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw1)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")
				}

				operate("3、设置申请带宽为字母如'10abzjb',保存") {
						puts "设置总带宽为#{@tc_bw4}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw4)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")
				}

				operate("4、设置申请带宽为中文'带宽'，保存") {
						puts "设置总带宽为#{@tc_bw5}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@tc_bw5)
						@options_page.save_traffic #提交
						error_msg = @options_page.error_msg
						puts "ERROR TIP:#{error_msg}".to_gbk
						assert_equal(@tc_bw_error1, error_msg, "未提示保存失败")
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
