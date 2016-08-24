#
# description:
# 总带宽限制应该限制WAN口入方向的流量，而不是LAN侧流量
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {

		attr = {"id" => "ZLBF_27.1.3", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_ftp_time          = 15
				@tc_cap_gap           = 5
				#kpbs 最小值
				@tc_bandwidth_min     = 1
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为DHCP".to_gbk
						@wan_page.set_dhcp(@browser, @browser.url)
						sys_page = RouterPageObject::SystatusPage.new(@browser)
						sys_page.open_systatus_page(@browser.url)
						wan_type = sys_page.get_wan_type
						wan_addr = sys_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@ts_wan_mode_dhcp}/, wan_type, '接入类型错误！'
				}

				operate("2、设置带宽为最小值#{@tc_bandwidth_min}kpbs,查看带宽是否受限") {
						#打开高级设置
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_min) #设置总带宽
						@options_page.save_traffic #保存
						@options_page.traffic_ctl
						sleep 4
						bw_total = @options_page.total_bw
						assert_equal(@tc_bandwidth_min.to_s, bw_total, "设置最小带宽成功")
				}

		end

		def clearup

				operate("1、取消带宽控制") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}
		end

}
