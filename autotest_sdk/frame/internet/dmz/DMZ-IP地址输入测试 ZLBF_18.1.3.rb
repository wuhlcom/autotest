#
# description:
#   产品有问题,输入与LAN相同的IP地址提示"路由器局域网IP地址格式错误"，应该提示"不能输入与路由器局域网IP相同的IP"
#   输入与局域网不同网段的IP能保存成功
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
		attr = {"id" => "ZLBF_18.1.3", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_wait_time= 3
				@tc_dmz_ip1  = "0.0.0.0"
				@tc_dmz_ip2  = "255.255.255.255"
				@tc_dmz_ip3  = "0.192.168.254"

				@tc_dmz_ip4 = "224.0.0.2"
				@tc_dmz_ip5 = "240.0.0.2"

				@tc_dmz_ip6 = "256"
				@tc_dmz_ip7 = "-11"
				@tc_dmz_ip8 = "192.168.256.254"
				@tc_dmz_ip9 = "192.-11.25.254"

				@tc_dmz_ip10 = "192.168.100.255"
				@tc_dmz_ip11 = "192.168.100.0"

				@tc_dmz_ip12 = "10.10.10.3"

				@tc_dmz_ip13 = "127.0.0.2"

				@tc_ipaddr_error = "IP地址格式错误"

		end

		def process

				operate("1、在“IP地址”输入全0，全1，或0开头地址或0结尾地址，如：0.0.0.0，255.255.255.255，0.0.0.1，192.0.0.0是否允许输入；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败")
						sleep @tc_wait_time
						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time
						#打开dmz开关
						@advance_iframe.button(id: @ts_tag_dmzsw).click if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_off).exists?
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip1}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip1)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip2}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip2)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip3}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip2)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}

				operate("2、在“IP地址”输入D类地址或E类地址、组播地址，如：224.1.1.1，240.1.1.1，255.1.1.1，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip4}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip4)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip5}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip5)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}

				operate("3、在“IP地址”输入大于255或小于0或小数的数字，如：256，-11，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip6}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip6)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip7}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip7)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip8}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip8)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip9}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip9)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}

				operate("4、在“IP地址”输入广播地址，如：192.168.2.255,10.255.255.255，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip10}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip10)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip11}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip11)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

				}

				operate("5、输入与LAN口IP同一个地址，如：192.168.100.1，是否允许输入；") {
						ip_info   = netsh_if_ip_show(nicname: @ts_nicname, type: "addresses")
						@tc_pc_gw = ip_info[:gateway][0]
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_pc_gw}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_pc_gw)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}

				operate("6、输入与DUT WAN口相同网段的地址，是否允许输入；") {
						# 配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip12}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip12)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}

				operate("7、输入回环地址，如：127.0.0.1，是否允许输入；") {
						#配置dmz 服务器ip
						puts "输入DMZ服务器地址为#{@tc_dmz_ip13}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(@tc_dmz_ip13)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}

				operate("8、在IP地址输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {
						#配置dmz 服务器ip
						tc_dmz_ip1="abc"
						tc_dmz_ip2=" "
						tc_dmz_ip3="#*"
						puts "输入DMZ服务器地址为#{tc_dmz_ip1}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(tc_dmz_ip1)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						puts "输入DMZ服务器地址为空格".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(tc_dmz_ip2)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")

						puts "输入DMZ服务器地址为#{tc_dmz_ip3}".encode("GBK")
						@advance_iframe.text_field(id: @ts_tag_dmzip).set(tc_dmz_ip3)
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_wait_time
						error_tip = @advance_iframe.span(id: @ts_tag_virsrvip_err)
						assert(error_tip.exists?, "未提示输入错误")
						puts("ERROR TIP:#{error_tip.text}".encode("GBK"))
						assert_equal(@tc_ipaddr_error, error_tip.text, "提示内容错误")
				}


		end

		def clearup
				operate("2 取消DMZ") {
						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end

						#选择‘应用设置’
						application      = @advance_iframe.link(id: @ts_tag_application)
						application_name = application.class_name
						unless application_name == @ts_tag_select_state
								application.click
								sleep @tc_wait_time
						end

						#选择“DMZ设置”标签
						dmz       = @advance_iframe.link(id: @ts_tag_dmz)
						dmz_state = dmz.parent.class_name
						dmz.click unless dmz_state==@ts_tag_liclass
						sleep @tc_wait_time

						if @advance_iframe.button(id: @ts_tag_dmzsw, class_name: @ts_tag_dmzsw_on).exists?
								#关闭dmz开关
								@advance_iframe.button(id: @ts_tag_dmzsw).click
								#提交
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_wait_time
						end
				}
		end

}
