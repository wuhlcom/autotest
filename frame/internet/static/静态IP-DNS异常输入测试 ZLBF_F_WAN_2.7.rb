#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.19", "level" => "P4", "auto" => "n"}

		def prepare
				@tc_nodns          = "请输入DNS"
				@tc_dns_format_err = "DNS 格式有误"
				@tc_wait_time      = 1
				@tc_static_time    = 35
				@tc_flag           = false
		end

		def process

				operate("1、选择静态IP拨号方式；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为Static".to_gbk
						@wan_page.select_static(@browser.url)
				}

				operate("2、在DNS地址输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = @ts_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = @ts_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticGateway

						#主DNS测试
						tc_staticPriDns          =""
						puts "输入主DNS为空".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_nodns
								@tc_flag = true
						end
						assert_equal(@tc_nodns, error_tip, "错误提示内容不正确!")

						tc_staticPriDns =" "
						puts "输入主DNS为空格".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="0.0.0.0"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="255.255.255.255"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="0.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.10.255"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.10.0"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("3、DNS地址输入组播地址，如239.1.1.1，是否允许输入；") {
						tc_staticPriDns ="224.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("4、DNS地址输入E类地址，如240.1.1.1，是否允许输入；") {
						tc_staticPriDns ="240.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("5、DNS地址输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
						tc_staticPriDns ="127.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("6、DNS地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {
						tc_staticPriDns ="10.10.10"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="a.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="10.x.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.c.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.10.f"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")

						tc_staticPriDns ="maindns"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_page.static_dns_element.click
						@wan_page.static_dns = tc_staticPriDns
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip == @tc_dns_format_err
								@tc_flag = true
						end
						assert_equal(@tc_dns_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("如果存在次DNS，测试次DNS") {
						# if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
						# end
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
