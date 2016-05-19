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
				@tc_ip_gw_same_error = "网关和局域网IP不允许相同"
				@tc_ip_gw_seg_error  = "网关和局域网IP不在同一网段"
				@tc_static_time      = 50
				@tc_wait_time        = 2
				@tc_tip_time         = 10
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

				operate("2、在网关输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {
						#输入空地址
						tc_staticGateway =""
						puts "输入网关地址为空".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_nogw, error_tip.text, "错误提示内容不正确!")

						#0开头
						tc_staticGateway="0.10.10.2"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						#测试边界，1开头
						tc_staticIp     = "1.10.10.2"
						tc_staticGateway= "1.10.10.1"
						puts "输入网关地址为:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_tip_time, "未出现网络重启提示!".encode("GBK")) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						}
						sleep @tc_static_time

						#最大223
						tc_staticIp     = "223.10.10.2"
						tc_staticGateway= "223.10.10.1"
						puts "输入网关地址为:#{tc_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_tip_time, "未出现网络重启提示!".encode("GBK")) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						}
						sleep @tc_static_time

						#超出最大值，输入224
						tc_staticGateway= "224.10.10.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						#末尾输入0
						tc_staticGateway="10.10.10.0"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						#输入 255
						tc_staticGateway="10.10.10.255"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						#输入 254
						tc_staticGateway="10.10.10.254"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_tip_time, "未出现网络重启提示!".encode("GBK")) {
								@wan_iframe.div(class_name: @ts_tag_net_reset, text: @ts_tag_net_reset_text)
						}
						sleep @tc_static_time
				}

				operate("3、网关输入组播地址，如239.1.1.1，是否允许输入；") {
            #第二步已经测试
				}

				operate("4、网关输入E类地址，如240.1.1.1，是否允许输入；") {
						tc_staticGateway = "240.1.1.2"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")
				}

				operate("5、网关输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {
						tc_staticGateway = "127.0.0.2"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")
				}

				operate("6、网关输入与IP地址同一个地址，查看是否允许输入；") {
						puts "输入IP地址为:#{@ts_staticIp}".encode("GBK")
						puts "输入网关地址为:#{@ts_staticIp}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticIp)
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_gw_same_error, error_tip.text, "错误提示内容不正确!")
				}

				operate("7、网关地址与IP地址不在同一网段，查看是否允许输入；") {
						tc_staticIp      = "10.10.10.55"
						tc_staticGateway = "11.10.10.55"
						puts "输入IP地址为:#{tc_staticIp}".encode("GBK")
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(tc_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_ip_gw_seg_error, error_tip.text, "错误提示内容不正确!")
				}

				operate("8、IP地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {
						tc_staticGateway="10.10.10"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						tc_staticGateway="a.10.10.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						tc_staticGateway="10.a.10.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						tc_staticGateway="10.10.e.1"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						tc_staticGateway="10.10.10.c"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")

						tc_staticGateway="gateway"
						puts "输入网关地址为:#{tc_staticGateway}".encode("GBK")
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						3.times{
								break if @wan_iframe.text_field(:id, @ts_tag_staticGateway).value !=""
								@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(tc_staticGateway)
						}
						@wan_iframe.button(:id, @ts_tag_sbm).click
						error_tip = @wan_iframe.p(id: @ts_tag_lanerr)
						assert(error_tip.exists?, "未弹出错误提示!")
						puts "ERROR TIP INFO #{error_tip.text}".encode("GBK")
						assert_equal(@tc_gw_error, error_tip.text, "错误提示内容不正确!")
				}


		end

		def clearup
				operate("1 恢复默认DHCP接入") {
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
