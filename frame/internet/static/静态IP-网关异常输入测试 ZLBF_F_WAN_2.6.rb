#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.18", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_nogw             = "请输入网关"
				@tc_gw_error         = "网关格式有误"
				@tc_ip_gw_same_error = "IP和网关地址不能相同"
				@tc_ip_gw_seg_error  = "IP和网关地址不在同一网段"
				@tc_static_time      = 70
				@tc_wait_time        = 2

		end

		def process

				operate("1、选择静态IP拨号方式；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为static".to_gbk
						@wan_page.select_static(@browser.url)
				}

				operate("2、在网关输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
						#输入空地址
						tc_staticGateway = ""
						puts "输入网关地址为空".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = @ts_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = @ts_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway

						@wan_page.static_dns_element.click
						@wan_page.static_dns = @ts_staticPriDns

						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_nogw
								@tc_flag = true
						end
						assert_equal(@tc_nogw, error_tip, "错误提示内容不正确!")

						#0开头
						tc_staticGateway= " "
						puts "输入网关地址为空格".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						#0开头
						tc_staticGateway="0.10.10.2"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						#测试边界，1开头
						tc_staticIp     = "1.10.10.2"
						tc_staticGateway= "1.10.10.1"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						puts "输入网关为为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_static_time

						@systatus_page = RouterPageObject::SystatusPage.new(@browser)
						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						wan_gw   = @systatus_page.get_wan_gw
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						puts "查询到WAN网关IP为#{wan_gw}".to_gbk
						assert_equal(tc_staticIp, wan_addr, "静态IP#{tc_staticIp}配置失败!")
						assert_equal(tc_staticGateway, wan_gw, "静态IP网关#{tc_staticGateway}失败！")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'

						#最大223
						tc_staticIp     = "223.10.10.2"
						tc_staticGateway= "223.10.10.1"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						puts "输入网关为为:#{tc_staticGateway}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_static_time

						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_addr = @systatus_page.get_wan_ip
						wan_gw   = @systatus_page.get_wan_gw
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						puts "查询到WAN网关IP为#{wan_gw}".to_gbk
						assert_equal(tc_staticIp, wan_addr, "静态IP#{tc_staticIp}配置失败!")
						assert_equal(tc_staticGateway, wan_gw, "静态IP网关#{tc_staticGateway}失败！")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'

						#超出最大值，输入224
						tc_staticGateway= "224.10.10.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						#末尾输入0
						tc_staticGateway="10.10.10.0"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						#输入 255
						tc_staticGateway="10.10.10.255"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						#输入 254
						tc_staticIp     = "10.10.10.204"
						tc_staticGateway= "10.10.10.254"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_static_time

						@systatus_page.open_systatus_page(@browser.url)
						wan_type = @systatus_page.get_wan_type
						wan_gw   = @systatus_page.get_wan_gw
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN网关地址为#{wan_gw}".to_gbk
						assert_equal(tc_staticGateway, wan_gw, "网关#{tc_staticGateway}配置失败!")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
				}

				operate("3、网关输入组播地址，如239.1.1.1，是否允许输入；") {
						#第二步已经测试
				}

				operate("4、网关输入E类地址，如240.1.1.1，是否允许输入；") {
						tc_staticGateway = "240.1.1.2"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")
				}

				operate("5、网关输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
						tc_staticGateway = "127.0.0.2"
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")
				}

				operate("6、网关输入与IP地址同一个地址，查看是否允许输入；") {
						puts "输入IP地址为:#{@ts_staticIp}".encode("GBK")
						puts "输入网关地址为:#{@ts_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = @ts_staticIp
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_ip_gw_same_error, error_tip, "错误提示内容不正确!")
				}

				operate("7、网关地址与IP地址不在同一网段，查看是否允许输入；") {
						tc_staticIp      = "10.10.10.55"
						tc_staticGateway = "11.10.10.55"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_ip_gw_seg_error, error_tip, "错误提示内容不正确!")
				}

				operate("8、IP地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {
						tc_staticGateway="10.10.10"
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						tc_staticGateway="a.10.10.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						tc_staticGateway="10.a.10.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						tc_staticGateway="10.10.e.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						tc_staticGateway="10.10.10.c"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")

						tc_staticGateway="gateway"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = tc_staticGateway
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_gw_error
								@tc_flag = true
						end
						assert_equal(@tc_gw_error, error_tip, "错误提示内容不正确!")
				}


		end

		def clearup
				operate("1 恢复默认方式:DHCP") {
						if @tc_flag
								sleep @tc_static_time
						end
						@wan_page = RouterPageObject::WanPage.new(@browser)
						@wan_page.set_dhcp(@browser, @browser.url)
				}
		end

}
