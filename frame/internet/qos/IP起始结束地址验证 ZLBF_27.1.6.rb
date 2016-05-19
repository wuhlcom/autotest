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
				#kbps
				@tc_bandwidth_total = "100000"
				@tc_bandwidth_limit = "1024"
				@tc_bandwidth_empty = ""
				@tc_error_tip       = "请完整输入带宽限制"
				@tc_ip_error        = "地址段只允许输入1-254"
		end

		def process

				operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.select_traffic_sw
						@options_page.set_total_bw(@tc_bandwidth_total) #设置总带宽
				}

				operate("2、起始地址，结束地址，带宽大小分别为空，点击保存") {
						tc_qos_ip   = "100"
						tc_qos_ip2  = "200"
						tc_empty_ip = "" #ip地址为空
						#设置ip范围，设置第一条规则
						#设置规则1，流量控制的IP,设置ip范围
						puts "输入起始IP地址为空".encode("GBK")
						puts "结束地址为#{tc_qos_ip}".encode("GBK")
						puts "带宽为#{@tc_bandwidth_limit}".encode("GBK")
						@options_page.add_item
						@options_page.set_client_bw(1, tc_empty_ip, tc_qos_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_error_tip, error_tip, "提示信息内容错误!")

						puts "起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "输入结束IP地址为空".encode("GBK")
						puts "带宽为#{@tc_bandwidth_limit}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_empty_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_error_tip, error_tip, "提示信息内容错误!")

						#设置ip范围，设置第一条规则
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						puts "带宽为空".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_empty)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP :#{error_tip}".encode("GBK")
						assert_equal(@tc_error_tip, error_tip, "提示信息内容错误!")
				}

				operate("3、带宽控制的对规则1的起始结束地址边界进行测试") {
						#边界值测试
						#起始IP地址下边界
						tc_qos_ip  = "1"
						tc_qos_ip2 = "254"
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")

						#起始IP地址上边界
						puts "输入起始IP地址为#{tc_qos_ip2}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip2, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")

						# 结束IP地址下边界
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")

						# 结束IP地址上边界
						puts "输入起始IP地址为#{tc_qos_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						assert_empty(error_tip, "提示信息内容错误!")
				}

				operate("4、对起始IP和结束IP的无效等价类测试") {
						#边界值越界测试
						tc_qos_ip1     = "1"
						tc_qos_ip2     = "254"
						tc_qos_err_ip  = "0"
						tc_qos_err_ip2 = "255"

						#起始IP地址无效等价类
						puts "输入起始IP地址为#{tc_qos_err_ip}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_err_ip, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "提示信息内容错误!")

						puts "输入起始IP地址为#{tc_qos_err_ip2}".encode("GBK")
						puts "结束地址为#{tc_qos_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_err_ip2, tc_qos_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "提示信息内容错误!")

						#结束IP地址无效等价类
						puts "输入起始IP地址为#{tc_qos_ip1}".encode("GBK")
						puts "结束地址为#{tc_qos_err_ip}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip1, tc_qos_err_ip, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "提示信息内容错误!")

						puts "输入结束IP地址为#{tc_qos_ip1}".encode("GBK")
						puts "结束地址为#{tc_qos_err_ip2}".encode("GBK")
						@options_page.set_client_bw(1, tc_qos_ip1, tc_qos_err_ip2, @ts_tag_bandlimit, @tc_bandwidth_limit)
						@options_page.save_traffic #保存
						error_tip = @options_page.error_msg
						puts "ERROR TIP #{error_tip}".encode("GBK")
						assert_equal(@tc_ip_error, error_tip, "提示信息内容错误!")
				}

				operate("5、输入其他异常值，例如输入字母，汉字，特殊字符，小数，留空，0等值，点击保存，是否能保存成功") {
						#特殊符号
						tc_qos_ip      = "10"
						tc_qos_err_ip  = " " #空格
						tc_qos_err_ip2 = "地址" #中文
						tc_qos_err_ip3 = "@" #符号
						tc_qos_err_ip4 = "c" #字母

						puts "起始IP地址无效等价类，输入无效的地址会被自动删除".to_gbk
						puts "输入起始IP地址为空格".encode("GBK") #空格
						@options_page.bw_ip_min0=tc_qos_err_ip
						sleep @tc_wait_time
						rs1=@options_page.bw_ip_min0
						assert_empty(rs1, "起始IP能输入空格")

						puts "输入起始IP地址为：#{tc_qos_err_ip2}".encode("GBK") #中文
						@options_page.bw_ip_min0=tc_qos_err_ip2
						sleep @tc_wait_time
						rs2=@options_page.bw_ip_min0
						assert_empty(rs2, "起始IP能输入中文:#{tc_qos_err_ip2}")

						puts "输入起始IP地址为：#{tc_qos_err_ip3}".encode("GBK") #符号
						@options_page.bw_ip_min0=tc_qos_err_ip3
						sleep @tc_wait_time
						rs3=@options_page.bw_ip_min0
						assert_empty(rs3, "起始IP能输入特殊符号:#{tc_qos_err_ip3}")

						puts "输入起始IP地址为：#{tc_qos_err_ip4}".encode("GBK") #字母
						@options_page.bw_ip_min0=tc_qos_err_ip4
						sleep @tc_wait_time
						rs4=@options_page.bw_ip_min0
						assert_empty(rs4, "起始IP能输入字母#{tc_qos_err_ip4}")

						puts "结束IP地址无效等价类，输入无效的地址会被自动删除".to_gbk
						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK") #空格
						puts "输入结束IP地址为空格".encode("GBK")
						@options_page.bw_ip_min0=tc_qos_err_ip
						@options_page.bw_ip_max0=tc_qos_err_ip
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "结束IP地址能输入空格")

						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK") #中文
						puts "输入结束IP地址为：#{tc_qos_err_ip2}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip2
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "结束IP地址能输入：#{tc_qos_err_ip2}")

						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK") #符号
						puts "输入结束IP地址为：#{tc_qos_err_ip3}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip3
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "结束IP地址能输入：#{tc_qos_err_ip3}")

						puts "输入起始IP地址为:#{tc_qos_ip}".encode("GBK") #字母
						puts "输入结束IP地址为：#{tc_qos_err_ip4}".encode("GBK")
						@options_page.bw_ip_max0=tc_qos_err_ip4
						sleep @tc_wait_time
						rs_end=@options_page.bw_ip_max0
						assert_empty(rs_end, "结束IP地址能输入：#{tc_qos_err_ip4}")
				}


		end

		def clearup

				operate("1 删除流量控制配置") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.select_traffic_ctl(@browser.url)
						@options_page.delete_item_all
						@options_page.unselect_traffic_sw
						@options_page.save_traffic #保存
				}
		end

}
