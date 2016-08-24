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
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框") {
						####未配置宽带控制时下载统计
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
				}

				operate("2、设置申请带宽为最小值如:1kbps，点击保存") {
						puts "设置总带宽为#{@ts_bw_min}".to_gbk
						@options_page.select_traffic_sw #打开总带宽控制
						@options_page.set_total_bw(@ts_bw_min)
						@options_page.save_traffic #提交
				}

				operate("3、设置申请带宽为中间某个值，如:80000kbps，点击保存") {
						tc_bw_mid = @ts_bw_max.to_i-100
						puts "设置总带宽为#{tc_bw_mid}".to_gbk
						@options_page.set_total_bw(tc_bw_mid)
						@options_page.save_traffic #提交
						rs = @options_page.total_bw
						assert_equal(tc_bw_mid, rs, "设置总带宽失败")
				}

				operate("4、设置申请带宽为最大值如:9999999kbps，点击保存") {
						puts "设置总带宽为#{@tc_total_bwmax}".to_gbk
						@options_page.set_total_bw(@tc_total_bwmax)
						@options_page.save_traffic #提交
						rs = @options_page.total_bw
						assert_equal(@tc_total_bwmax, rs, "设置总带宽失败")
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
