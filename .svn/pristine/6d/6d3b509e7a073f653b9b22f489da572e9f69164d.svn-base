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
		end

		def process

				operate("1、在子网掩码处输入255.255.255.255，0.0.0.0，是否允许输入；") {
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

						#输入空掩码
						tc_staticNetmask =""
						puts "输入掩码地址为空".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_nomask, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="255.255.255.255"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="0.0.0.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")
				}

				operate("2、在子网掩码处输入从左到右不连续为1的地址，如：255.0.255.0,255.128.255.0等是否可以输入；") {
						tc_staticNetmask ="0.255.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="255.0.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="255.128.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")
				}

				operate("3、在子网掩码输入错误格式地址，如256.255.255.255，a.a.a.a等；") {
						tc_staticNetmask ="256.255.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="255.256.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="255.255.256.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click

						tc_staticNetmask ="a.255.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="255.a.255.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="yanma"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")

						tc_staticNetmask ="a.a.a.0"
						puts "输入掩码地址为#{tc_staticNetmask}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(tc_staticNetmask)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						@tc_error_info = error_tip.text
						puts "ERROR TIP INFO #{@tc_error_info}".encode("GBK")
						assert_equal(@tc_mask_format_err, @tc_error_info, "错误提示内容不正确!")
				}


		end

		def clearup
				operate("1 恢复默认DHCP接入") {
						#如果非法MASK也保存成功了这里需要进行等待
						if !@tc_error_info.nil?&&@tc_error_info.empty?
								puts "sleep #{@tc_static_time} for net reseting..."
								sleep @tc_static_time
						end

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
								puts "sleep  #{@tc_static_time} for net reseting..."
								sleep @tc_static_time
						end
				}
		end

}
