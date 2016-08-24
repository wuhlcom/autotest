#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.16", "level" => "P1", "auto" => "n"}

		def prepare

				@tc_wait_time       = 2
				@tc_qos_time        = 5
				@tc_net_time        = 35
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"

		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {
						#打开高级设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						sleep @tc_wait_time #流量管理界面响应较慢，增加延迟
						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						sleep @tc_wait_time #流量管理界面响应较慢，增加延迟
						####开启总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						unless qos_sw.checked?
								qos_sw.click
						end
						#####设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2、假设当前LAN口地址为192.168.100.1，设置规则1-规则5起始地址段分别为192.168,100.2-192.168.2.6，结束地址段与起始地址段相同。模式都为限制最大带宽为100kbps，启用规则1-5") {
						@pc_ip_last = @ts_pc_ip.split(".").last.to_i
						if @pc_ip_last<=200
								p "ip address last segment"
								@tc_ip_min2 = (@pc_ip_last+1).to_s
								@tc_ip_max2 =(@pc_ip_last+1).to_s
								puts "规则2：设置起始IP#{@tc_ip_min2}，结束IP#{@tc_ip_max2}".encode("GBK")
								@tc_ip_min3 = (@pc_ip_last+2).to_s
								@tc_ip_max3 = (@pc_ip_last+4).to_s
								puts "规则3：设置起始IP#{@tc_ip_min3}，结束IP#{@tc_ip_max3}".encode("GBK")
								@tc_ip_min4 = (@pc_ip_last+5).to_s
								@tc_ip_max4 = (@pc_ip_last+5).to_s
								puts "规则4：设置起始IP#{@tc_ip_min4}，结束IP#{@tc_ip_max4}".encode("GBK")
								@tc_ip_min5 = (@pc_ip_last+6).to_s
								@tc_ip_max5 = (@pc_ip_last+8).to_s
								puts "规则5：设置起始IP#{@tc_ip_min5}，结束IP#{@tc_ip_max5}".encode("GBK")
						elsif @pc_ip_last>200
								p "ip address last segment"
								@tc_ip_min2 = (@pc_ip_last-1).to_s
								@tc_ip_max2 = (@pc_ip_last-1).to_s
								puts "规则2：设置起始IP#{@tc_ip_min2}，结束IP#{@tc_ip_max2}".encode("GBK")
								@tc_ip_min3 = (@pc_ip_last-2).to_s
								@tc_ip_max3 = (@pc_ip_last-4).to_s
								puts "规则3：设置起始IP#{@tc_ip_min3}，结束IP#{@tc_ip_max3}".encode("GBK")
								@tc_ip_min4 = (@pc_ip_last-5).to_s
								@tc_ip_max4 = (@pc_ip_last-5).to_s
								puts "规则4：设置起始IP#{@tc_ip_min4}，结束IP#{@tc_ip_max4}".encode("GBK")
								@tc_ip_min5 = (@pc_ip_last-6).to_s
								@tc_ip_max5 = (@pc_ip_last-8).to_s
								puts "规则5：设置起始IP#{@tc_ip_min5}，结束IP#{@tc_ip_max5}".encode("GBK")
						end
						@pc_ip_last=@pc_ip_last.to_s
						#设置ip范围，设置第一条规则
						@advance_iframe.text_field(id: @ts_tag_range_min).set(@pc_ip_last)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(@pc_ip_last)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#设置ip范围 设置第二条规则
						@advance_iframe.text_field(id: @ts_tag_range_min2).set(@tc_ip_min2)
						@advance_iframe.text_field(id: @ts_tag_range_max2).set(@tc_ip_max2)
						#选择 受限最大带宽
						mode_select2 = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						mode_select2.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size2).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#设置ip范围 设置第三条规则
						@advance_iframe.text_field(id: @ts_tag_range_min3).set(@tc_ip_min3)
						@advance_iframe.text_field(id: @ts_tag_range_max3).set(@tc_ip_max3)
						#选择 保障最小带宽
						mode_select3 = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						mode_select3.select(@ts_tag_bandensure)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size3).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#设置ip范围 设置第四条规则
						@advance_iframe.text_field(id: @ts_tag_range_min4).set(@tc_ip_min4)
						@advance_iframe.text_field(id: @ts_tag_range_max4).set(@tc_ip_min4)
						#选择 受限最大带宽
						mode_select4 = @advance_iframe.select_list(id: @ts_tag_band_mode4)
						mode_select4.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size4).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#设置ip范围 设置第五条规则
						@advance_iframe.text_field(id: @ts_tag_range_min5).set(@tc_ip_min5)
						@advance_iframe.text_field(id: @ts_tag_range_max5).set(@tc_ip_max5)
						#选择 保障最小带宽
						mode_select5 = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						mode_select5.select(@ts_tag_bandensure)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size5).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						# 配置完成后，刷新浏览器，并查看配置是否存在
						puts "Refresh browser......"
						@browser.refresh
						sleep @tc_wait_time
						#打开高级设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						puts "checkout the bandwidth setting"
						#第一条规则
						min_ip        = @advance_iframe.text_field(id: @ts_tag_range_min).value
						max_ip        = @advance_iframe.text_field(id: @ts_tag_range_max).value
						#选择 受限最大带宽
						mode_select   = @advance_iframe.select_list(id: @ts_tag_band_mode)
						select_state  = mode_select.selected?(@ts_tag_bandlimit)
						#限制带宽
						bandwith_limit=@advance_iframe.text_field(id: @ts_tag_band_size).value
						assert_equal(@pc_ip_last, min_ip, "规则1的起始ip#{@pc_ip_last}保存失败")
						assert_equal(@pc_ip_last, max_ip, "规则1的结束ip#{@pc_ip_last}保存失败")
						assert(select_state, "规则1的模式#{@ts_tag_bandlimit}保存失败")
						assert_equal(@tc_bandwidth_limit, bandwith_limit, "规则1的带宽设置为#{@tc_bandwidth_limit}保存失败")

						# 第二条规则
						min_ip2        = @advance_iframe.text_field(id: @ts_tag_range_min2).value
						max_ip2        = @advance_iframe.text_field(id: @ts_tag_range_max2).value
						#选择 受限最大带宽
						mode_select2   = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						select_state2  = mode_select2.selected?(@ts_tag_bandlimit)
						#限制带宽
						bandwith_limit2= @advance_iframe.text_field(id: @ts_tag_band_size2).value
						assert_equal(@tc_ip_min2, min_ip2, "规则2的起始ip#{@tc_ip_min2}保存失败")
						assert_equal(@tc_ip_max2, max_ip2, "规则2的结束ip#{@tc_ip_max2}保存失败")
						assert(select_state2, "规则2的模式#{@ts_tag_bandlimit}保存失败")
						assert_equal(@tc_bandwidth_limit, bandwith_limit2, "规则2的带宽设置为#{@tc_bandwidth_limit}保存失败")

						# 第三条规则
						min_ip3        = @advance_iframe.text_field(id: @ts_tag_range_min3).value
						max_ip3        = @advance_iframe.text_field(id: @ts_tag_range_max3).value
						#选择 受限最大带宽
						mode_select3   = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						select_state3  = mode_select3.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit3=@advance_iframe.text_field(id: @ts_tag_band_size3).value
						assert_equal(@tc_ip_min3, min_ip3, "规则3的起始ip#{@tc_ip_min3}保存失败")
						assert_equal(@tc_ip_max3, max_ip3, "规则3的结束ip#{@tc_ip_max3}保存失败")
						assert(select_state3, "规则3的模式#{@ts_tag_bandlimit}保存失败")
						assert_equal(@tc_bandwidth_limit, bandwith_limit3, "规则3的带宽设置为#{@tc_bandwidth_limit}保存失败")

						# 第四条规则
						min_ip4        = @advance_iframe.text_field(id: @ts_tag_range_min4).value
						max_ip4        = @advance_iframe.text_field(id: @ts_tag_range_max4).value
						#选择 保障最小带宽
						mode_select4   = @advance_iframe.select_list(id: @ts_tag_band_mode4)
						select_state4  = mode_select4.selected?(@ts_tag_bandlimit)
						#限制带宽
						bandwith_limit4=@advance_iframe.text_field(id: @ts_tag_band_size).value
						assert_equal(@tc_ip_min4, min_ip4, "规则4的起始ip#{@tc_ip_min4}保存失败")
						assert_equal(@tc_ip_max4, max_ip4, "规则4的结束ip#{@tc_ip_max4}保存失败")
						assert(select_state4, "规则4的模式#{@ts_tag_bandlimit}保存失败")
						assert_equal(@tc_bandwidth_limit, bandwith_limit4, "规则4的带宽设置为#{@tc_bandwidth_limit}保存失败")

						# 第五条规则
						min_ip5        = @advance_iframe.text_field(id: @ts_tag_range_min5).value
						max_ip5        = @advance_iframe.text_field(id: @ts_tag_range_max5).value
						#选择 受限最大带宽
						mode_select5   = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						select_state5  = mode_select5.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit5= @advance_iframe.text_field(id: @ts_tag_band_size5).value
						assert_equal(@tc_ip_min5, min_ip5, "规则5的起始ip#{@tc_ip_min5}保存失败")
						assert_equal(@tc_ip_max5, max_ip5, "规则5的结束ip#{@tc_ip_max5}保存失败")
						assert(select_state5, "规则5的模式#{@ts_tag_bandlimit}保存失败")
						assert_equal(@tc_bandwidth_limit, bandwith_limit5, "规则5的带宽设置为#{@tc_bandwidth_limit}保存失败")
				}

				operate("3、对每条规则点击“清除”按钮，是否会清除掉页面上的配置") {
						# bandwidth_table = @advance_iframe.table(class_name: @ts_tag_band_tb)
						# @advance_iframe.table(class_name: @ts_tag_band_tb).trs[1][5].link(title: @ts_tag_clear_btn).click
						#删除规则1
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						#删除规则2
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						#删除规则3
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						#删除规则4
						@advance_iframe.td(text: "4").parent.tds[5].link.click
						#删除规则5
						@advance_iframe.td(text: "5").parent.tds[5].link.click
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
				}

				operate("4、清除后点击保存，刷新页面，确保信息已经清空") {
						puts "Refresh browser again......"
						@browser.refresh
						sleep @tc_wait_time
						#打开高级设置
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end
						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end
						#第一条规则
						empty_ip      = ""
						empty_bandwith=""
						min_ip        = @advance_iframe.text_field(id: @ts_tag_range_min).value
						max_ip        = @advance_iframe.text_field(id: @ts_tag_range_max).value
						#选择 受限最大带宽
						mode_select   = @advance_iframe.select_list(id: @ts_tag_band_mode)
						select_state  = mode_select.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit=@advance_iframe.text_field(id: @ts_tag_band_size).value
						assert_equal(empty_ip, min_ip, "规则1的起始ip清除失败")
						assert_equal(empty_ip, max_ip, "规则1的结束ip清除失败")
						assert(select_state, "规则1的模式未恢复成：#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit, "规则1的带宽限制清空失败")

						#第二条规则
						min_ip2        = @advance_iframe.text_field(id: @ts_tag_range_min2).value
						max_ip2        = @advance_iframe.text_field(id: @ts_tag_range_max2).value
						#选择 受限最大带宽
						mode_select2   = @advance_iframe.select_list(id: @ts_tag_band_mode2)
						select_state2  = mode_select2.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit2=@advance_iframe.text_field(id: @ts_tag_band_size2).value
						assert_equal(empty_ip, min_ip2, "规则2的起始ip清除失败")
						assert_equal(empty_ip, max_ip2, "规则2的结束ip清除失败")
						assert(select_state2, "规则2的模式未恢复成：#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit2, "规则2的带宽限制清空失败")

						#第三条规则
						min_ip3        = @advance_iframe.text_field(id: @ts_tag_range_min3).value
						max_ip3        = @advance_iframe.text_field(id: @ts_tag_range_max3).value
						#选择 受限最大带宽
						mode_select3   = @advance_iframe.select_list(id: @ts_tag_band_mode3)
						select_state3  = mode_select3.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit3= @advance_iframe.text_field(id: @ts_tag_band_size3).value
						assert_equal(empty_ip, min_ip3, "规则3的起始ip清除失败")
						assert_equal(empty_ip, max_ip3, "规则3的结束ip清除失败")
						assert(select_state3, "规则3的模式未恢复成：#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit3, "规则3的带宽限制清空失败")

						#第四条规则
						min_ip4        = @advance_iframe.text_field(id: @ts_tag_range_min4).value
						max_ip4        = @advance_iframe.text_field(id: @ts_tag_range_max4).value
						#选择 受限最大带宽
						mode_select4   = @advance_iframe.select_list(id: @ts_tag_band_mode4)
						select_state4  = mode_select4.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit4= @advance_iframe.text_field(id: @ts_tag_band_size4).value
						assert_equal(empty_ip, min_ip4, "规则4的起始ip清除失败")
						assert_equal(empty_ip, max_ip4, "规则4的结束ip清除失败")
						assert(select_state4, "规则4的模式未恢复成：#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit4, "规则4的带宽限制清空失败")

						#第五条规则
						min_ip5        = @advance_iframe.text_field(id: @ts_tag_range_min5).value
						max_ip5        = @advance_iframe.text_field(id: @ts_tag_range_max5).value
						#选择 受限最大带宽
						mode_select5   = @advance_iframe.select_list(id: @ts_tag_band_mode5)
						select_state5  = mode_select5.selected?(@ts_tag_bandensure)
						#限制带宽
						bandwith_limit5= @advance_iframe.text_field(id: @ts_tag_band_size5).value
						assert_equal(empty_ip, min_ip5, "规则5的起始ip清除失败")
						assert_equal(empty_ip, max_ip5, "规则5的结束ip清除失败")
						assert(select_state5, "规则5的模式未恢复成：#{@ts_tag_bandensure}")
						assert_equal(empty_bandwith, bandwith_limit5, "规则5的带宽限制清空失败")
				}

		end

		def clearup
				operate("1 关闭流量控制") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						#打开流量管理
						bandwith = @advance_iframe.link(id: @ts_tag_bandwidth)
						unless bandwith.class_name=~/#{@ts_tag_select_state}/
								bandwith.click
						end

						#打开流量控制
						traffic_control = @advance_iframe.link(id: @ts_tag_traffic)
						unless traffic_control.parent.class_name==@ts_tag_liclass
								traffic_control.click
						end

						#删除规则1
						@advance_iframe.td(text: "1").parent.tds[5].link.click
						#删除规则2
						@advance_iframe.td(text: "2").parent.tds[5].link.click
						#删除规则3
						@advance_iframe.td(text: "3").parent.tds[5].link.click
						#删除规则4
						@advance_iframe.td(text: "4").parent.tds[5].link.click
						#删除规则5
						@advance_iframe.td(text: "5").parent.tds[5].link.click

						####关闭总开关
						qos_sw = @advance_iframe.checkbox(id: @ts_tag_bandsw)
						if qos_sw.checked?
								qos_sw.click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_qos_time
						end
				}
		end

}
