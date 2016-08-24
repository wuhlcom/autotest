#
# description:
# 该用例只测试反复重启多次(五次)，每次重启后PPPOE业务正常
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.30", "level" => "P3", "auto" => "n"}

		def prepare
				@tc_reboot_time  = 120
				@tc_relogin_time = 60
				@tc_net_time     = 60
				@tc_wait_time    = 2
		end

		def process

				operate("1、设置DUT的WAN拨号方式为PPPoE,，DNS为自动获取方式，认证方法设为自动，并填写正确的拨号用户名和密码，提交；") {
						#设置为PPPOE拨号
						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						assert(@wan_iframe.exists?, "打开外网设置失败")
						rs1=@wan_iframe.link(:id => @ts_tag_wired_mode_link).class_name
						unless rs1 =~/#{@ts_tag_select_state}/
								@wan_iframe.span(:id => @ts_tag_wired_mode_span).click
						end
						pppoe_radio       = @wan_iframe.radio(id: @ts_tag_wired_pppoe)
						pppoe_radio_state = pppoe_radio.checked?
						unless pppoe_radio_state
								pppoe_radio.click
						end
						puts "设置PPPOE帐户名和PPPOE密码！".to_gbk
						@wan_iframe.text_field(id: @ts_tag_pppoe_usr).set(@ts_pppoe_usr)
						@wan_iframe.text_field(id: @ts_tag_pppoe_pw).set(@ts_pppoe_pw)
						@wan_iframe.button(id: @ts_tag_sbm).click
						puts "set pppoe mode,waiting for net reset..."
						sleep @tc_net_time
				}

				operate("2、查看DUT是否拨号成功；") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end

						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						wan_addr       = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_type       = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						assert_match @ip_regxp, wan_addr, 'PPPOE获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '接入类型错误！'

						rs = ping(@ts_web)
						assert(rs, "PPPOE方式路由器无法连接外网")
				}

				operate("4、软件重启DUT 5次，查看DUT拨号是否成功，DUT是否出现异常。") {
						5.times do |i|
								puts "第#{i+1}次重启路由器".encode("GBK")
								if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
										@browser.execute_script(@ts_close_div)
								end

								@browser.refresh
								@browser.span(id: @ts_tag_reboot).click
								reboot_confirm = @browser.button(class_name: @ts_tag_reboot_confirm)
								assert reboot_confirm.exists?, "未提示重启路由器要确认!"
								reboot_confirm.click

								puts "sleep #{@tc_reboot_time} for system reboot...."
								sleep(@tc_reboot_time) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
								rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_relogin_time)
								assert rs, "重启路由器失败未跳转到登录页面!"
								#重新登录路由器
								rs = login_no_default_ip(@browser)
								assert(rs, "重新登录路由器失败!")

								#多次查询状态页面,防止状态页面显示失败
								3.times do
										@browser.refresh
										@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
										@browser.span(:id => @ts_tag_status).click
										sleep @tc_wait_time
										@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
										break if @status_iframe.b(:id => @ts_tag_wan_ip).exists?
										sleep @tc_status_time
								end

								wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
								puts "重启后接入类型为#{wan_type}".encode("GBK")
								assert_match @ip_regxp, wan_addr, '重启后PPPOE获取ip地址失败！'
								assert_match /#{@ts_wan_mode_pppoe}/, wan_type, '重启后接入类型错误！'

								rs = ping(@ts_web)
								assert(rs, "重启后PPPOE方式路由器无法连接外网")
						end
				}


		end

		def clearup

				operate("1 恢复默认DHCP接入") {
						if @browser.span(:id => @ts_tag_netset).exists?
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
						unless rs1.class_name =~/#{@tc_tag_select_state}/
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
								sleep @tc_net_time
						end
				}
		end

}
