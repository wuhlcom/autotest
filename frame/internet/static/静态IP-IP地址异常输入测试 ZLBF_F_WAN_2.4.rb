#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.16", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_noip_tip     = "请输入 IP 地址"
				@tc_ip_error_tip = "IP地址格式错误"
				@tc_static_time  = 70
				@tc_wait_time    = 1
				@tc_flag         = false
		end

		def process

				operate("1、选择静态IP拨号方式；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为Static".to_gbk
						@wan_page.select_static(@browser.url)
				}

				operate("2、在IP地址输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
						#输入空地址
						tc_staticIp =""
						puts "输入IP地址为空".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = @ts_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticGateway

						@wan_page.static_dns_element.click
						@wan_page.static_dns = @ts_staticPriDns

						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_noip_tip
								@tc_flag = true
						end
						assert_equal(@tc_noip_tip, error_tip, "错误提示内容不正确!")

						#输入空格
						tc_staticIp =" "
						puts "输入IP地址为空格".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						#0开头
						tc_staticIp="0.10.10.2"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

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

						#测试边界:首分段最大223
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
						tc_staticIp = "224.10.10.2"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save

						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						#末尾输入0
						tc_staticIp= "10.10.10.0"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time

						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						#输入 255
						tc_staticIp= "10.10.10.255"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time

						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						#输入 254
						tc_staticIp     = "10.10.10.254"
						tc_staticGateway= "10.10.10.1"
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
						wan_addr = @systatus_page.get_wan_ip
						puts "查询到WAN接入方式为#{wan_type}".to_gbk
						puts "查询到WAN IP为#{wan_addr}".to_gbk
						assert_equal(tc_staticIp, wan_addr, "静态IP#{tc_staticIp}配置失败!")
						assert_match /#{@ts_wan_mode_static}/, wan_type, '接入类型错误！'
				}

				operate("3、IP地址输入组播地址，如239.1.1.1，是否允许输入；") {
						#第二步中已经测试
				}

				operate("4、IP地址输入E类地址，如240.1.1.1，是否允许输入；") {
						tc_staticIp = "240.1.1.2"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.select_static(@browser.url)
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")
				}

				operate("5、IP地址输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
						tc_staticIp = "127.0.0.2"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")
				}

				operate("6、IP地址输入错误格式地址，如192.168.10，a.a.a.a等；") {
						tc_staticIp="10.10.10"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						tc_staticIp="10.10.10.a"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						tc_staticIp="10.10.-1.10"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						tc_staticIp="10.@.10.10"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						tc_staticIp="10.10.10. 111"
						puts "输入IP地址为:#{tc_staticIp},地址中有空格".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")

						tc_staticIp="*.10.10.10"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = tc_staticIp
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_ip_error_tip
								@tc_flag = true
						end
						assert_equal(@tc_ip_error_tip, error_tip, "错误提示内容不正确!")
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
