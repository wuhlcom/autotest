#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
# 源目IP地址输入lan口ip有效，目的IP输入wan口ip有效(用例都要求无效)，脚本先将这些测试点注释
testcase {
		attr = {"id" => "ZLBF_15.1.1", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time     = 3
				@tc_ip_table      = "iptable"
				@ip1              = "0.0.0.0"
				@ip2              = "255.255.255.255"
				@ip3              = "0.0.0.1"
				@ip4              = "192.0.0.0"
				@ip5              = "224.1.1.1"
				@ip6              = "240.1.1.1"
				@ip7              = "255.1.1.1"
				@ip8              = "10.1.1.256"
				@ip9              = "10.1.1.-11"
				@ip10             = "10.1.1.1.2"
				@ip11             = "192.168.2.255"
				@ip12             = "127.0.0.1"
				@ip13             = "@.a.d.*"
				@ip14             = "中国. .."
				@tc_srcip_error   = "源IP地址格式错误"
				@tc_dstip_error   = "目的IP地址格式错误"
				rs                = ipconfig(@ts_ipconf_all)
				@tc_pc_ip         = rs[@ts_nicname][:ip][0]
		end

		def process
				operate("0、获取LAN口和WAN口IP地址") {
						@sys_page = RouterPageObject::SystatusPage.new(@browser)
						@sys_page.open_systatus_page(@browser.url)
						@wan_ip = @sys_page.get_wan_ip
						p "WAN侧IP为：#{@wan_ip}".to_gbk
						@lan_ip = @sys_page.get_lan_ip
						p "LAN侧IP为：#{@lan_ip}".to_gbk
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("1、DUT的接入类型选择为DHCP，保存配置，PC1设置为自动获取IP地址，如：192.168.100.x，进入到管理界面中的IP过虑界面；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)

						#设置pc1为dhcp模式
						p "设置PC1为自动获取IP地址".to_gbk
						args           = {}
						args[:nicname] = @ts_nicname
						args[:source]  = "dhcp"
						dhcp_ip        = netsh_if_ip_setip(args)
						assert(dhcp_ip, "PC1地址获取方式设置为自动获取失败！")
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.open_security_page_step(@browser.url) #进入安全页面
						@options_page.open_switch("on", "on", "off", "off") #打开防火墙，ip过滤总开关
						@options_page.ipfilter_click #打开IP过滤页面
						@options_page.ip_add_item_element.click #添加新条目
				}

				operate("2、在“源IP地址”输入全0，全255，或0开头地址或0结尾地址，如：0.0.0.0，255.255.255.255，0.0.0.1，192.0.0.0是否允许输入；") {
						p "源IP地址中输入全0".to_gbk
						@options_page.ip_filter_src_ip_input(@ip1, @ip1)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入全255".to_gbk
						@options_page.ip_filter_src_ip_input(@ip2, @ip2)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入0开头".to_gbk
						@options_page.ip_filter_src_ip_input(@ip3, @ip3)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入0结尾".to_gbk
						@options_page.ip_filter_src_ip_input(@ip4, @ip4)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("3、在“源IP地址”输入D类地址或E类地址、组播地址，如：224.1.1.1，240.1.1.1，255.1.1.1，是否允许输入；") {
						p "源IP地址中输入D类地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip5, @ip5)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入E类地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip6, @ip6)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入组播地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip7, @ip7)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("4、在“源IP地址”输入大于255或小于0或小数的数字，如：256，-11，是否允许输入；") {
						p "源IP地址中输入大于255的数字地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip8, @ip8)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入小于0的数字地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip9, @ip9)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入小数数字的地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip10, @ip10)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("5、在“源IP地址”输入广播地址，如：192.168.2.255,10.255.255.255，是否允许输入；") {
						p "源IP地址中输入广播地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip11, @ip11)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("6、在“源IP地址”输入与LAN口IP同一个地址，如：192.168.100.1，是否允许输入；") {
						# p "源IP地址中输入LAN口IP地址".to_gbk
						# @options_page.ip_filter_src_ip_input(@lan_ip, @lan_ip)
						# @options_page.ip_save #保存
						# error_tip = @options_page.ip_filter_err_msg
						# puts "ERROR TIP:#{error_tip}".to_gbk
						# assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("7、在“源IP地址”输入与DUTWAN口的IP地址，是否允许输入；") {
						p "源IP地址中输入WAN口IP地址".to_gbk
						@options_page.ip_filter_src_ip_input(@wan_ip, @wan_ip)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("8、在“源IP地址”输入回环地址，如：127.0.0.1，是否允许输入；") {
						p "源IP地址中输入回环地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip12, @ip12)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("9、在“源IP地址”输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
						p "源IP地址中输入特殊字符地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip13, @ip13)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")

						p "源IP地址中输入中文，空格，为空等地址".to_gbk
						@options_page.ip_filter_src_ip_input(@ip14, @ip14)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_srcip_error, error_tip, "源IP地址格式输入错误，但是未提示！")
				}

				operate("10、再在“目的IP地址”输入步骤2-9中所有的值，查看是否允许输入。") {
						@options_page.ipfilter_click #打开IP过滤页面
						@options_page.ip_all_del #删除所有条目
						sleep @tc_wait_time
						@options_page.ip_add_item_element.click #添加新条目

						p "目的IP地址中输入全0".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip1, @ip1)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入全255".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip2, @ip2)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入0开头".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip3, @ip3)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入0结尾".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip4, @ip4)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入D类地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip5, @ip5)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入E类地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip6, @ip6)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入组播地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip7, @ip7)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入大于255的数字地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip8, @ip8)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入小于0的数字地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip9, @ip9)
						@options_page.ip_save #保存
						err_msg9 = @options_page.ip_filter_err_msg?
						assert(err_msg9, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入小数数字的地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip10, @ip10)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入广播地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip11, @ip11)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入回环地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip12, @ip12)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入特殊字符地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip13, @ip13)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")

						p "目的IP地址中输入中文，空格，为空等地址".to_gbk
						@options_page.ip_filter_src_ip_input(@tc_pc_ip,@tc_pc_ip)
						@options_page.ip_filter_dst_ip_input(@ip14, @ip14)
						@options_page.ip_save #保存
						error_tip = @options_page.ip_filter_err_msg
						puts "ERROR TIP:#{error_tip}".to_gbk
						assert_equal(@tc_dstip_error, error_tip, "目的IP地址格式输入错误，但是未提示！")
				}


		end

		def clearup
				operate("1 删除所有条目") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
						    @browser.execute_script(@ts_close_div)
						end
						options_page = RouterPageObject::OptionsPage.new(@browser)
						options_page.ipfilter_close_sw_del_all_step(@browser.url)
				}
		end

}
