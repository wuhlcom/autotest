#
# description:
# author:wuhongliang
# bug 子网掩码输入为全0也能保存
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.17", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_nomask          = "请输入子网掩码"
				@tc_mask_format_err = "子网掩码格式不正确"
				@tc_static_time     = 40
				@tc_wait_time       = 2
				@tc_flag            = false
		end

		def process

				operate("1、在子网掩码处输入255.255.255.255，0.0.0.0，是否允许输入；") {
						@wan_page = RouterPageObject::WanPage.new(@browser)
						puts "设置接入方式为静态接入".to_gbk
						@wan_page.select_static(@browser.url)

						#输入空地址
						tc_staticNetmask =""
						puts "输入掩码地址为空".encode("GBK")
						@wan_page.static_ip_element.click #增加元素点击操作以防输入失败
						@wan_page.static_ip = @ts_staticIp

						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask

						@wan_page.static_gateway_element.click
						@wan_page.static_gateway = @ts_staticGateway

						@wan_page.static_dns_element.click
						@wan_page.static_dns = @ts_staticPriDns
						@wan_page.save
						sleep @tc_wait_time

						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_nomask
								@tc_flag = true
						end
						assert_equal(@tc_nomask, error_tip, "错误提示内容不正确!")

						#输入空地址
						tc_staticNetmask =" "
						puts "输入掩码地址为空格".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="255.255.255.255"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="0.0.0.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("2、在子网掩码处输入从左到右不连续为1的地址，如：255.0.255.0,255.128.255.0等是否可以输入；") {
						tc_staticNetmask ="0.255.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="255.0.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="255.128.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")
				}

				operate("3、在子网掩码输入错误格式地址，如256.255.255.255，a.a.a.a等；") {
						tc_staticNetmask ="256.255.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="255.256.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="255.255.256.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="a.255.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="255.a.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="yanma"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")

						tc_staticNetmask ="a.a.a.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_page.static_netmask_element.click
						@wan_page.static_netmask = tc_staticNetmask
						@wan_page.save
						sleep @tc_wait_time
						error_tip = @wan_page.static_err_msg
						puts "ERROR TIP INFO：#{error_tip}".encode("GBK")
						unless error_tip==@tc_mask_format_err
								@tc_flag = true
						end
						assert_equal(@tc_mask_format_err, error_tip, "错误提示内容不正确!")
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
