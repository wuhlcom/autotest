#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_27.1.6", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time       = 2
				@tc_qos_time        = 5
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"
				@tc_start_ip_err    = "请输入起始IP地址"
				@tc_end_ip_err      = "请输入结束IP地址"
				@tc_bandwidth_err   = "请输入带宽"
				@tc_ip_addr_err     = "IP地址格式错误"
				@tc_qos_tip         = "配置成功"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {
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
						####设置总带宽
						@advance_iframe.text_field(id: @ts_tag_wideband).set(@tc_bandwidth_total)
				}

				operate("2、起始地址，结束地址，带宽大小分别为空，点击保存") {
						tc_qos_ip   = "100"
						tc_qos_ip2  = "200"
						tc_empty_ip = "" #ip地址为空
						#设置ip范围，设置第一条规则
						puts "输入起始IP地址为空".encode("GBK")
						puts "结束地址为#{tc_qos_ip}".encode("GBK")
						puts "带宽为#{@tc_bandwidth_limit}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_empty_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_start_ip_err, error_info, "未输入起始IP地址")

						puts "起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "输入结束IP地址为空".encode("GBK")
						puts "带宽为#{@tc_bandwidth_limit}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_empty_ip)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_start_ip_err, error_info, "未输入起始IP地址")

						#设置ip范围，设置第一条规则
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						puts "带宽为空".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_bandwidth_err, error_info, "未输入起始IP地址")
				}

				# operate("3、假设当前LAN口IP地址为192.168.1.1，对规则1的起始结束地址进行设置，分别为1和254，点击保存") {
				operate("3、带宽控制的对规则1的起始结束地址边界进行测试") {
						#边界值测试
						#起始IP地址下边界
						tc_qos_ip  = "1"
						tc_qos_ip2 = "254"
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						Watir::Wait.until(@tc_qos_time, "未弹出配置成功提示".encode("GBK")) {
								@advance_iframe.div(text: /#{@tc_qos_tip}/).exists?
						}

						#起始IP地址上边界
						puts "输入起始IP地址为#{tc_qos_ip2}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip2)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						Watir::Wait.until(@tc_qos_time, "未弹出配置成功提示".encode("GBK")) {
								@advance_iframe.div(text: /#{@tc_qos_tip}/).exists?
						}

						#结束IP地址下边界
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						Watir::Wait.until(@tc_qos_time, "未弹出配置成功提示".encode("GBK")) {
								@advance_iframe.div(text: /#{@tc_qos_tip}/).exists?
						}

						#结束IP地址上边界
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						Watir::Wait.until(@tc_qos_time, "未弹出配置成功提示".encode("GBK")) {
								@advance_iframe.div(text: /#{@tc_qos_tip}/).exists?
						}
				}

				# operate("4、假设当前LAN口IP地址为192.168.1.1，对规则1的起始结束地址进行设置，分别为2和255，点击保存") {
				operate("4、对起始IP和结束IP的无效等价类测试") {
						#边界值越界测试
						tc_qos_ip2     = "254"
						tc_qos_err_ip  = "0"
						tc_qos_err_ip2 = "255"

						#起始IP地址无效等价类
						puts "输入起始IP地址为#{tc_qos_err_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_err_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_ip_addr_err, error_info, "输入起始IP地址错误")

						puts "输入起始IP地址为#{tc_qos_err_ip2}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_err_ip2)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time

						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_ip_addr_err, error_info, "输入起始IP地址错误")

						#结束IP地址无效等价类
						puts "输入起始IP地址为#{tc_qos_ip2}".encode("GBK")
						puts "结束地址为#{tc_qos_err_ip}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip2)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_err_ip)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_ip_addr_err, error_info, "输入结束IP地址错误")

						puts "输入结束IP地址为#{tc_qos_ip2}".encode("GBK")
						puts "结束地址为#{tc_qos_err_ip}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip2)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_err_ip2)
						#选择 受限最大带宽
						mode_select = @advance_iframe.select_list(id: @ts_tag_band_mode)
						mode_select.select(@ts_tag_bandlimit)
						#限制带宽
						@advance_iframe.text_field(id: @ts_tag_band_size).set(@tc_bandwidth_limit)
						sleep @tc_wait_time
						#提交
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_qos_time
						error_tip  = @advance_iframe.span(id: @ts_tag_band_err)
						error_info = error_tip.text
						puts "ERROR TIP #{error_info}".encode("GBK")
						assert(error_tip.exists?, "未提示输入错误")
						assert_equal(@tc_ip_addr_err, error_info, "输入结束IP地址错误")
				}

				# operate("5、假设当前LAN口IP地址为192.168.1.10，对规则1的起始结束地址进行设置，分别为9和11，点击保存") {
				#
				# }

				operate("6、输入其他异常值，例如输入字母，汉字，特殊字符，小数，留空，0等值，点击保存，是否能保存成功") {
						#特殊符号
						tc_qos_ip      = "1"
						tc_qos_err_ip  = " " #空格
						tc_qos_err_ip2 = "地址" #中文
						tc_qos_err_ip3 = "@" #符号
						tc_qos_err_ip4 = "c" #字母

						#起始IP地址无效等价类，输入无效的地址会被自动删除
						puts "输入起始IP地址为空格".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_err_ip)
						rs1 = @advance_iframe.text_field(id: @ts_tag_range_min).value
						assert(rs1.empty?, "起始IP能输入空格")

						puts "输入起始IP地址为：#{tc_qos_err_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_err_ip2)
						sleep @tc_wait_time
						rs2 = @advance_iframe.text_field(id: @ts_tag_range_min).value
						assert(rs2.empty?, "起始IP能输入中文:#{tc_qos_err_ip2}")

						puts "输入起始IP地址为：#{tc_qos_err_ip3}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_err_ip3)
						sleep @tc_wait_time
						rs3 = @advance_iframe.text_field(id: @ts_tag_range_min).value
						assert(rs3.empty?, "起始IP能输入特殊符号:#{tc_qos_err_ip3}")

						puts "输入起始IP地址为：#{tc_qos_err_ip4}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_err_ip4)
						sleep @tc_wait_time
						rs4 = @advance_iframe.text_field(id: @ts_tag_range_min).value
						assert(rs4.empty?, "起始IP能输入字母#{tc_qos_err_ip4}")

						#起始IP地址无效等价类，输入无效的地址会被自动删除
						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK")
						puts "输入结束IP地址为空格".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_err_ip)
						sleep @tc_wait_time
						rs1_max = @advance_iframe.text_field(id: @ts_tag_range_max).value
						assert(rs1_max.empty?, "结束IP地址能输入空格")

						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK")
						puts "输入结束IP地址为：#{tc_qos_err_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_err_ip2)
						sleep @tc_wait_time
						rs2_max = @advance_iframe.text_field(id: @ts_tag_range_max).value
						assert(rs2_max.empty?, "结束IP地址能输入：#{tc_qos_err_ip2}")

						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK")
						puts "输入结束IP地址为：#{tc_qos_err_ip3}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_err_ip3)
						sleep @tc_wait_time
						rs3_max = @advance_iframe.text_field(id: @ts_tag_range_max).value
						assert(rs3_max.empty?, "结束IP地址能输入：#{tc_qos_err_ip3}")

						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK")
						puts "输入结束IP地址为：#{tc_qos_err_ip4}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_range_min).set(tc_qos_ip)
						@advance_iframe.text_field(id: @ts_tag_range_max).set(tc_qos_err_ip4)
						sleep @tc_wait_time
						rs4_max = @advance_iframe.text_field(id: @ts_tag_range_max).value
						assert(rs4_max.empty?, "结束IP地址能输入：#{tc_qos_err_ip4}")
				}


		end

		def clearup

				operate("1 删除流量控制配置") {
						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)

						#打开流量管理
						bandwith        = @advance_iframe.link(id: @ts_tag_bandwidth)
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
