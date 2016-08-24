#
# description:
# author:wuhongliang
# pptp拨号失败应该诊断失败，但实际诊断成功
#
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.6", "level" => "P3", "auto" => "n"}

		def prepare

				@tc_wait_time                = 3
				@tc_pptp_time                = 10
				@tc_status_wait              = 10
				@tc_net_time                 = 50
				@tc_tag_wan_span             = "set_network"
				@tc_tag_wan_mode_span        = "wire"
				@tc_tag_wan_mode_link        = "tab_ip"
				@tc_tag_wire_mode_radio_dhcp = "ip_type_dhcp"

				@tc_tag_link_href    = "pptp.asp"
				@tc_tag_li_class     = "active"
				@tc_tag_ul_id        = "safe_ul"
				@tc_wire_mode        = "PPTP"
				@tc_err_pptp_usr     = "pptpfail"
				@tc_err_pptp_pw      = "pptpfail"
				@tc_tag_server_id    = "lanIp"
				@tc_tag_pptp_usr     = "username"
				@tc_tag_pptp_pw      = "psd"
				@tc_tag_networking   = "networksetting"
				@tc_tag_select_state = "selected"
				@tc_tag_advance_div  = "aui_state_lock aui_state_focus" #focus在后表示选中了当前div
				@tc_tag_style_zindex = "z-index"
		end

		def process

				operate("1、配置拨号方式为PPTP；") {
						option        = @browser.link(:id => @ts_tag_options)
						option_appear = option.wait_until_present(@tc_wait_time)
						option.click
						@advance_ifrmame = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_ifrmame.exists?, '打开高级设置失败！')

						network_class = @advance_ifrmame.link(:id, @tc_tag_networking).class_name
						unless network_class =~ /#{@tc_tag_select_state}/
								@advance_ifrmame.link(:id, @tc_tag_networking).click
								sleep @tc_wait_time
						end
						@advance_ifrmame.link(:href, @tc_tag_link_href).click
						sleep @tc_wait_time
						pptp_li = @advance_ifrmame.ul(:id, @tc_tag_ul_id).lis[2].class_name
						assert_equal @tc_tag_li_class, pptp_li, '选择PPTP连接方式失败！'
						puts "设置非法的pptp帐户".to_gbk
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@tc_err_pptp_usr}"
						puts "PPTP PassWD:#{@tc_err_pptp_pw}"

						@advance_ifrmame.text_field(:id, @tc_tag_server_id).set(@ts_pptp_server_ip)
						@advance_ifrmame.text_field(:id, @tc_tag_pptp_usr).set(@tc_err_pptp_usr)
						@advance_ifrmame.text_field(:id, @tc_tag_pptp_pw).set(@tc_err_pptp_pw)
						@advance_ifrmame.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time
						# Watir::Wait.until(@tc_wait_time, "PPTP设置成功提示出现") {
						# 		@pptp_tip=@advance_ifrmame.div(class_name: @ts_tag_reset, text: /#{@ts_tag_pptp_set}/)
						# 		@pptp_tip.present?
						# }
						# Watir::Wait.while(@tc_net_time, "PPTP设置成功提示消失") {
						# 		@pptp_tip.present?
						# }

						#高级设置页面背景DIV
						file_div         = @browser.div(class_name: @tc_tag_advance_div)
						zindex_value     = file_div.style(@tc_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏高级设置背景DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)

						#打开路由器状态页面
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_wait #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						Watir::Wait.until(@tc_status_wait, "状态页面加载失败") {
								@status_iframe.b(:id => @ts_tag_wan_type).present?
						}
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						refute_match @ts_tag_ip_regxp, wan_addr, 'PPTP应无法获取到地址！'
						assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
				}

				operate("2、输入错误的账号密码，使拨号不成功，点击系统诊断，查看诊断结果；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						#open diagnose
						@browser.link(id: @ts_tag_diagnose).click()
						sleep @tc_wait_time
						#得个@browser对象下各个窗口对象的句柄对象
						@tc_handles = @browser.driver.window_handles
						assert(@tc_handles.size==2, "未打开诊断窗口")
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						sleep @tc_status_wait

						Watir::Wait.while(@tc_diagnose_time, "诊断过程出错") {
								puts "#{@ts_tag_diag_detecting}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait.until(@tc_wait_time, "诊断结果出错") {
								puts "#{@ts_tag_diag_fini_fail}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_fini_fail).present?
						}

						tc_diag_3gdial =@browser.span(id: @ts_tag_diag_3gdial, text: @tc_tag_diag_3gdial_text).exists?
						assert(tc_diag_3gdial, "未显示3G状态")
						tc_diag_3gdial_status = @browser.span(id: @ts_tag_diag_3gdial_status).text
						puts "3G Dial status:#{tc_diag_3gdial_status}".to_gbk
						assert_equal(tc_diag_3gdial_status, @ts_tag_diag_fail, "3G状态应该显示为'异常'")

						tc_diag_wan =@browser.span(id: @ts_tag_diag_wan, text: @ts_tag_diag_wan_text).exists?
						assert(tc_diag_wan, "未显示WAN物理状态")
						tc_diag_wan_status = @browser.span(id: @ts_tag_diag_wan_status).text
						puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
						assert_equal(tc_diag_wan_status, @ts_tag_diag_success, "显示WAN物理状态异常")

						tc_diag_internet =@browser.span(id: @ts_tag_diag_internet, text: @ts_tag_diag_internet_text).exists?
						assert(tc_diag_internet, "未显示WAN网络状态")
						tc_diag_internet_status = @browser.span(id: @ts_tag_diag_internet_status).text
						puts "Internet status:#{tc_diag_internet_status}".to_gbk
						assert_equal(tc_diag_internet_status, @ts_tag_diag_fail, "显示WAN网络状态应该为'异常'")
						tc_diag_internet_err = @browser.div(text: /#{@ts_tag_diag_wan_err}/)
						assert(tc_diag_internet_err.exists?, "PPTP拨号失败时提示内容错误!")

						tc_diag_hardware = @browser.span(id: @ts_tag_diag_hardware, text: @ts_tag_diag_hardware_text).exists?
						assert(tc_diag_hardware, "未显示路由器物理状态")
						tc_diag_hardware_status = @browser.span(id: @ts_tag_diag_hardware_status).text
						puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
						assert_equal(tc_diag_hardware_status, @ts_tag_diag_success, "显示路由器物理状态异常")

						tc_diag_netspeed = @browser.span(id: @ts_tag_diag_netspeed, text: @ts_tag_diag_netspeed_text).exists?
						assert(tc_diag_netspeed, "未显示连接速率")
						tc_diag_netspeed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
						puts "NetSpeed status:#{tc_diag_netspeed_status}".to_gbk
						assert_equal(tc_diag_netspeed_status, @ts_tag_diag_fail, "显示连接速率异常")
						# tc_diag_netspeed_err1 = @browser.p(text: @ts_tag_diag_netspeed_err1)
						tc_diag_netspeed_err2 = @browser.p(text: @ts_tag_diag_netspeed_err2)
						tc_diag_netspeed_err3 = @browser.p(text: @ts_tag_diag_netspeed_err3)
						# assert(tc_diag_netspeed_err1.exists?, "速率异常丢包提示错误!")
						assert(tc_diag_netspeed_err2.exists?, "速率异常域名提示错误!")
						assert(tc_diag_netspeed_err3.exists?, "速率异常端口提示错误!")

						tc_diag_cpu=@browser.span(id: @ts_tag_diag_cpu, text: @ts_tag_diag_cpu_text).exists?
						assert(tc_diag_cpu, "未显示处理器状态")
						tc_diag_cpu_status = @browser.div(xpath: @ts_tag_diag_cpu_xpath).text
						puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
						assert_match(@ts_tag_cpu_type_reg, tc_diag_cpu_status, "显示处理器类型异常")
						assert_match(@ts_tag_cpu_name_reg, tc_diag_cpu_status, "显示处理器名称异常")
						assert_match(@ts_tag_cpu_load_reg, tc_diag_cpu_status, "显示处理器负载异常")

						tc_diag_mem = @browser.span(id: @ts_tag_diag_mem, text: @ts_tag_diag_mem_text).exists?
						assert(tc_diag_mem, "未显示内存状态")
						tc_diag_mem_status = @browser.div(xpath: @ts_tag_diag_mem_xpath).text
						puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
						assert_match(@ts_tag_mem_total_reg, tc_diag_mem_status, "显示内存总大小类型异常")
						assert_match(@ts_tag_mem_useful_reg, tc_diag_mem_status, "显示可用内存异常")
						assert_match(@ts_tag_mem_cache_reg, tc_diag_mem_status, "显示缓存空间异常")

				}

				operate("3、输入正确的账号密码，使拨号成功") {
						#debug
						sleep 20
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[0])
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						option = @browser.link(:id => @ts_tag_options)
						option.click
						option_appear    = option.wait_until_present(@tc_wait_time)
						@advance_ifrmame = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_ifrmame.exists?, '打开高级设置失败！')

						network_class = @advance_ifrmame.link(:id, @tc_tag_networking).class_name
						unless network_class =~ /#{@tc_tag_select_state}/
								@advance_ifrmame.link(:id, @tc_tag_networking).click
								sleep @tc_wait_time
						end
						@advance_ifrmame.link(:href, @tc_tag_link_href).click
						sleep @tc_wait_time
						pptp_li = @advance_ifrmame.ul(:id, @tc_tag_ul_id).lis[2].class_name
						assert_equal @tc_tag_li_class, pptp_li, '选择PPTP连接方式失败！'
						puts "设置合法的PPTP帐户".to_gbk
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_ifrmame.text_field(:id, @tc_tag_server_id).set(@ts_pptp_server_ip)
						@advance_ifrmame.text_field(:id, @tc_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_ifrmame.text_field(:id, @tc_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_ifrmame.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time
						# Watir::Wait.until(@tc_wait_time, "PPTP设置成功提示出现") {
						# 		@pptp_tip=@advance_ifrmame.div(class_name: @ts_tag_reset, text: /#{@ts_tag_pptp_set}/)
						# 		@pptp_tip.present?
						# }
						# Watir::Wait.while(@tc_net_time, "PPTP设置成功提示消失") {
						# 		@pptp_tip.present?
						# }
						#高级设置页面背景DIV
						if @browser.div(class_name: @tc_tag_advance_div).exists?
								file_div         = @browser.div(class_name: @tc_tag_advance_div)
								zindex_value     = file_div.style(@tc_tag_style_zindex)
								#找到背景根DIV
								background_zindex=(zindex_value.to_i-1).to_s
								background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

								#隐藏高级设置背景DIV
								@browser.execute_script("$(arguments[0]).hide();", file_div)
								#隐藏背景根DIV
								@browser.execute_script("$(arguments[0]).hide();", background_div)
						end
						#打开路由器状态页面
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_wait #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						Watir::Wait.until(@tc_status_wait, "状态页面加载失败") {
								@status_iframe.b(:id => @ts_tag_wan_type).present?
						}
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP法获取到地址！'
						assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'
				}

				operate("4、输入正确的账号密码，使拨号成功，点击系统诊断，查看诊断结果；") {
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						@browser.refresh #刷新页面重新诊断
						sleep @tc_status_wait
						Watir::Wait.while(@tc_diagnose_time, "诊断过程出错") {
								puts "#{@ts_tag_diag_detecting}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_detecting).present?
						}
						Watir::Wait.until(@tc_wait_time, "诊断结果出错") {
								puts "#{@ts_tag_diag_fini_success}".to_gbk
								@browser.h1(id: @ts_tag_diag_detect, text: @ts_tag_diag_fini_success).present?
						}
						tc_diag_3gdial =@browser.span(id: @ts_tag_diag_3gdial, text: @tc_tag_diag_3gdial_text).exists?
						assert(tc_diag_3gdial, "未显示3G状态")
						tc_diag_3gdial_status = @browser.span(id: @ts_tag_diag_3gdial_status).text
						puts "3G Dial status:#{tc_diag_3gdial_status}".to_gbk
						assert_equal(tc_diag_3gdial_status, @ts_tag_diag_fail, "3G状态应该显示为'异常'")

						tc_diag_wan =@browser.span(id: @ts_tag_diag_wan, text: @ts_tag_diag_wan_text).exists?
						assert(tc_diag_wan, "未显示WAN物理状态")
						tc_diag_wan_status = @browser.span(id: @ts_tag_diag_wan_status).text
						puts "WAN Port status:#{tc_diag_wan_status}".to_gbk
						assert_equal(tc_diag_wan_status, @ts_tag_diag_success, "显示WAN物理状态异常")

						tc_diag_internet =@browser.span(id: @ts_tag_diag_internet, text: @ts_tag_diag_internet_text).exists?
						assert(tc_diag_internet, "未显示WAN网络状态")
						tc_diag_internet_status = @browser.span(id: @ts_tag_diag_internet_status).text
						puts "Internet status:#{tc_diag_internet_status}".to_gbk
						assert_equal(tc_diag_internet_status, @ts_tag_diag_success, "显示WAN网络状态异常")

						tc_diag_hardware = @browser.span(id: @ts_tag_diag_hardware, text: @ts_tag_diag_hardware_text).exists?
						assert(tc_diag_hardware, "未显示路由器物理状态")
						tc_diag_hardware_status = @browser.span(id: @ts_tag_diag_hardware_status).text
						puts "Hardware status:#{tc_diag_hardware_status}".to_gbk
						assert_equal(tc_diag_hardware_status, @ts_tag_diag_success, "显示路由器物理状态异常")

						tc_diag_netspeed = @browser.span(id: @ts_tag_diag_netspeed, text: @ts_tag_diag_netspeed_text).exists?
						assert(tc_diag_netspeed, "未显示连接速率")
						tc_diag_netspeed_status = @browser.span(id: @ts_tag_diag_netspeed_status).text
						puts "Hardware status:#{tc_diag_netspeed_status}".to_gbk
						assert_equal(tc_diag_netspeed_status, @ts_tag_diag_success, "显示连接速率异常")

						tc_diag_cpu=@browser.span(id: @ts_tag_diag_cpu, text: @ts_tag_diag_cpu_text).exists?
						assert(tc_diag_cpu, "未显示处理器状态")
						tc_diag_cpu_status = @browser.div(xpath: @ts_tag_diag_cpu_xpath).text
						puts "CPU status:\n#{tc_diag_cpu_status}".to_gbk
						assert_match(@ts_tag_cpu_type_reg, tc_diag_cpu_status, "显示处理器类型异常")
						assert_match(@ts_tag_cpu_name_reg, tc_diag_cpu_status, "显示处理器名称异常")
						assert_match(@ts_tag_cpu_load_reg, tc_diag_cpu_status, "显示处理器负载异常")

						tc_diag_mem = @browser.span(id: @ts_tag_diag_mem, text: @ts_tag_diag_mem_text).exists?
						assert(tc_diag_mem, "未显示内存状态")
						tc_diag_mem_status = @browser.div(xpath: @ts_tag_diag_mem_xpath).text
						puts "MEM status:\n#{tc_diag_mem_status}".to_gbk
						assert_match(@ts_tag_mem_total_reg, tc_diag_mem_status, "显示内存总大小类型异常")
						assert_match(@ts_tag_mem_useful_reg, tc_diag_mem_status, "显示可用内存异常")
						assert_match(@ts_tag_mem_cache_reg, tc_diag_mem_status, "显示缓存空间异常")
				}

				operate("5、测试网不接入Internet，点击系统诊断，查看诊断结果；") {
##padding
				}


		end

		def clearup
				operate("1 恢复为默认的接入方式，DHCP接入") {
						sleep @tc_net_time #pptp接入提交过程中如果操作失败会导致路由器与pc短暂断开，所以这里加上等待
						unless @tc_handles.nil?
								@browser.driver.switch_to.window(@tc_handles[0])
						end

						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						if @browser.div(class_name: @tc_tag_advance_div).exists?
								puts "Close  advance setting..."
								#高级设置页面背景DIV
								file_div         = @browser.div(class_name: @tc_tag_advance_div)
								zindex_value     = file_div.style(@tc_tag_style_zindex)
								#找到背景根DIV
								background_zindex=(zindex_value.to_i-1).to_s
								background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

								#隐藏高级设置背景DIV
								@browser.execute_script("$(arguments[0]).hide();", file_div)
								#隐藏背景根DIV
								@browser.execute_script("$(arguments[0]).hide();", background_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         =@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@tc_tag_select_state}/
								@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								sleep @tc_net_time
						end
				}

		end

}
