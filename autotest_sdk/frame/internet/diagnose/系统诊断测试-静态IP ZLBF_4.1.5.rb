#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
		attr = {"id" => "ZLBF_4.1.5", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_wait_time         = 2
				@tc_status_time       = 5
				@tc_net_time          = 50
				@tc_err_staticIp      = '110.110.110.223'
				@tc_err_staticNetmask = '255.255.255.0'
				@tc_err_staticGateway = '110.110.110.1'
				@tc_err_staticPriDns  = '110.110.110.1'
		end

		def process

				operate("1、配置外网设置拨号方式为静态IP；") {
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

						puts "设置WAN静态IP无法连接外网，地址为：#{@tc_err_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@tc_err_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@tc_err_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@tc_err_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@tc_err_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time #等待网络连接成功
						#打开路由器状态页面
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time #等待页面显示
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match(/#{@tc_err_staticIp}/, wan_addr, '配置静态ip失败！')
						assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
				}

				operate("2、输入错误的静态上网IP，点击系统诊断，查看诊断结果；") {
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
						sleep @tc_status_time
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
						tc_diag_internet_err = @browser.div(text: @ts_tag_diag_internet_static_err)
						assert(tc_diag_internet_err.exists?, "网络异常提示内容错误!")

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
						tc_diag_netspeed_err1 = @browser.p(text: @ts_tag_diag_netspeed_err1)
						tc_diag_netspeed_err2 = @browser.p(text: @ts_tag_diag_netspeed_err2)
						tc_diag_netspeed_err3 = @browser.p(text: @ts_tag_diag_netspeed_err3)
						assert(tc_diag_netspeed_err1.exists?, "速率异常丢包提示错误!")
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

				operate("3、输入正确的静态上网IP，点击系统诊断，查看诊断结果；") {
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[0])
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, '打开外网设置失败！')

						puts "设置正确的静态IP地址为：#{@ts_staticIp}".to_gbk
						@wan_iframe.text_field(:id, @ts_tag_staticIp).set(@ts_staticIp)
						@wan_iframe.text_field(:id, @ts_tag_staticNetmask).set(@ts_staticNetmask)
						@wan_iframe.text_field(:id, @ts_tag_staticGateway).set(@ts_staticGateway)
						@wan_iframe.text_field(:id, @ts_tag_staticPriDns).set(@ts_staticPriDns)
						if @wan_iframe.text_field(:id, @ts_tag_backupDns).exists?
								@wan_iframe.text_field(:id, @ts_tag_backupDns).set(@ts_staticBackupDns)
						end
						@wan_iframe.button(:id, @ts_tag_sbm).click
						sleep @tc_net_time #等待网络连接成功
						#打开路由器状态页面
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						sleep @tc_status_time #等待页面显示
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match(/#{@ts_staticIp}/, wan_addr, '配置静态ip失败！')
						assert_match(/#{@ts_wan_mode_static}/, wan_type, '接入类型错误！')
				}

				operate("4、输入正确的静态上网IP，点击系统诊断，查看诊断结果；") {
						#通过句柄来切换不同的windows窗口
						@browser.driver.switch_to.window(@tc_handles[1])
						@browser.refresh #刷新页面重新诊断
						sleep @tc_status_time
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

				}


		end

		def clearup
				operate("1 恢复为默认的接入方式，DHCP接入") {
						unless @tc_handles.nil?
								@browser.driver.switch_to.window(@tc_handles[0])
						end

						if @browser.div(class_name: @ts_aui_state).exists? || @browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						sleep @tc_wait_time
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe
						#设置wan连接方式为网线连接
						rs1         =@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						flag        =false
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
								flag=true
						end

						#查询是否为为dhcp模式
						dhcp_radio       = @wan_iframe.radio(id: @ts_tag_wired_dhcp)
						dhcp_radio_state = dhcp_radio.checked?

						#设置WIRE WAN为dhcp
						unless dhcp_radio_state
								dhcp_radio.click
								flag=true
						end

						if flag
								@wan_iframe.button(:id, @ts_tag_sbm).click
								puts "Waiting for net reset..."
								sleep @tc_net_time
						end
				}
		end

}
