#
# description:
# MAC输入的有效性与接入方式无关，所以这里不对接入方式做修改
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.39", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_clonemac_tip = "请输入正确的MAC地址"
				@tc_wait_time    = 2
				@tc_clone_time   = 45
		end

		def process

				operate("1、登录路由器,打开MAC克隆界面") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
				}

				operate("2、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {
						tc_mac = "00:00:00:00:00:00"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.open_mac_clone_sw(@browser.url)
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("3、输入MAC地址：FF:FF:FF:FF:FF:FF，查看是否允许输入保存；") {
						tc_mac = "FF:FF:FF:FF:FF:FF"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("4、输入MAC地址以01:00:5e开头的MAC地址，如：01:00:5e:00:00:01,查看是否允许输入保存；") {
						tc_mac = "01:00:5e:00:00:01"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("5、输入MAC地址为空，查看是否允许输入保存；") {
						tc_mac = ""
						puts "Clone MAC address为空".to_gbk
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("6、输入MAC地址含有特殊符号，查看是否允许输入保存；") {
						tc_mac = "00:@F:5e:00:00:01"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("7、输入MAC地址含有非16进制字母G，查看是否允许输入保存；") {
						tc_mac = "00:33:5G:00:00:01"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("8、输入MAC地址有非16进制字母Z，查看是否允许输入保存；") {
						tc_mac = "00:33:5E:1Z:00:01"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("9、输入MAC地址格式有缺失，查看是否允许输入保存；") {
						tc_mac = "00:33:5E:10:0:01"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("10、输入MAC地址格式不正确，查看是否允许输入保存；") {
						tc_mac = "00:33:5E:10:00:001"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("11、输入MAC地址为空格，查看是否允许输入保存；") {
						tc_mac = " "
						puts "Clone MAC address为空格".to_gbk
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_wait_time
						clone_error = @options_page.clone_error
						puts "ERROR TIP:#{clone_error}".encode("GBK")
						assert_equal(@tc_clonemac_tip, clone_error, "提示内容错误!")
				}

				operate("12、输入MAC地址包含大小写：90:AB:CD:EF:ab:cf，查看是否允许输入保存；") {
						tc_mac = "90:AB:CD:EF:ab:cf"
						puts "Clone MAC address: #{tc_mac}"
						@options_page.input_clone_mac(tc_mac)
						@options_page.clone_save
						sleep @tc_clone_time
						@browser.refresh
						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)

						wan_mac = @systatus_page.get_wan_mac
						puts "查询到克隆后WAN MAC为#{wan_mac}".to_gbk
						puts "被克隆的MAC地址为#{tc_mac}".to_gbk
						assert_equal(tc_mac.upcase, wan_mac.upcase, "MAC地址克隆失败!")
				}


		end

		def clearup
				# operate("1 取消克隆") {
						@options_page = RouterPageObject::OptionsPage.new(@browser)
						@options_page.shutdown_clone(@browser.url)
				# }
		end

}
