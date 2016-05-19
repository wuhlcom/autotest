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
				@tc_static_time    = 50
				@tc_wait_time      = 2
				@tc_tip_time       = 10
		end

		def process

				operate("1、选择静态IP拨号方式；") {
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						static_radio = @wan_iframe.radio(:id => @ts_tag_wired_static)
						static_radio.click
						sleep @tc_wait_time
				}

				operate("2、在DNS地址输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
						#主DNS测试
						tc_staticPriDns =""
						puts "输入主DNS为空".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_nodns, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="0.0.0.0"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="255.255.255.255"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="0.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.10.255"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.10.0"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")
				}

				operate("3、DNS地址输入组播地址，如239.1.1.1，是否允许输入；") {
						tc_staticPriDns ="224.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")
				}

				operate("4、DNS地址输入E类地址，如240.1.1.1，是否允许输入；") {
						tc_staticPriDns ="240.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")
				}

				operate("5、DNS地址输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
						tc_staticPriDns ="127.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")
				}

				operate("6、DNS地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {
						tc_staticPriDns ="10.10.10"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="a.10.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="10.x.10.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")


						tc_staticPriDns ="10.10.c.1"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="10.10.10.f"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

						tc_staticPriDns ="maindns"
						puts "输入主DNS为#{tc_staticPriDns}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(tc_staticPriDns)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")
				}

				operate("如果存在次DNS，测试次DNS") {
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								puts "测试次DNS".encode("GBK")
								tc_staticBackupDns =""
								puts "输入次DNS为空".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
								@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
								@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)

								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="0.0.0.0"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="255.255.255.255"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="0.10.10.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="10.10.10.255"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="10.10.10.0"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

###########################
								tc_staticBackupDns ="224.10.10.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="240.10.10.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="127.10.10.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")


								tc_staticBackupDns ="10.10.10"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="a.10.10.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="10.x.10.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="10.10.c.1"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="10.10.10.f"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")

								tc_staticBackupDns ="maindns"
								puts "输入次DNS为#{tc_staticBackupDns}".encode("GBK")
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(tc_staticBackupDns)
								@wan_iframe.button(:id, @ts_tag_sbm).click
								error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
								assert(error_tip.exists?, "未弹出错误提示!")
								puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
								assert_equal(@tc_dns_format_err, error_tip.text, "错误提示内容不正确!")
						end
				}


		end

		def clearup

				operate("恢复默认DHCP接入") {
						if !@wan_iframe.exists? && @browser.span(:id => @ts_tag_netset).exists?
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						end

						flag = false
						#设置wan连接方式为网线连接
						rs1  = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
						unless rs1.class_name =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag = true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?
						#设置WIRE WAN为DHCP模式
						unless dhcp_radio_state
								dhcp_radio.click
								flag = true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_static_time
						end
				}
		end

}
