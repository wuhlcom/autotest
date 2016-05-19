#
# description:
# pc2 远程登录暂未实现
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
testcase {
		attr = {"id" => "ZLBF_30.1.1", "level" => "P1", "auto" => "n"}

		def prepare
				DRb.start_service
				@tc_server_obj          = DRbObject.new_with_uri(@ts_drb_server2)
				@tc_wait_time           = 2
				@tc_remote_time         = 5
				@tc_tag_wan_mode_span   = "wire"
				@tc_tag_wan_mode_link   = "tab_ip"
				@tc_tag_wire_mode_radio = "ip_type_dhcp"
				@tc_select_state        = "selected"
				@tc_wire_mode           = "DHCP"
				@tc_tag_liclass         = "active"
				@tc_tag_button_on       = "on"
				@tc_tag_button_off      = "off"
				@tc_tag_port            = "port"
				@tc_wait_time           = 2
				@tc_net_time            = 50
		end

		def process

				operate("1、DUT启动，设置WAN接入类型为DHCP，（假设获取到的地址为10.10.0.100）；") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
						assert(@status_iframe.exists?, "打开WAN状态失败！")
						wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						#先判断是否为dhcp模式如果不是则设置为dhcp模式
						unless wan_type=~/#{@tc_wire_mode}/
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								@browser.span(:id => @ts_tag_netset).click
								@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
								assert(@wan_iframe.exists?, "打开外网设置失败")

								rs1=@wan_iframe.link(:id => @tc_tag_wan_mode_link).class_name
								unless rs1=~/#{@tc_select_state}/
										@wan_iframe.span(:id => @tc_tag_wan_mode_span).click
								end

								#如果不是dhcp接入就先设置为dhcp接入
								dhcp_radio       = @wan_iframe.radio(id: @tc_tag_wire_mode_radio)
								dhcp_radio_state = dhcp_radio.checked?
								unless dhcp_radio_state
										dhcp_radio.click
										@wan_iframe.button(:id, @ts_tag_sbm).click
										sleep @tc_net_time
								end
								if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
										@browser.execute_script(@ts_close_div)
								end
								#重新查看网络状态
								@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
								@browser.span(:id => @ts_tag_status).click
								@status_iframe = @browser.iframe(src: @ts_tag_status_iframe_src)
								assert(@status_iframe.exists?, "重新打开WAN状态失败！")
								wan_type = @status_iframe.b(:id => @ts_tag_wan_type).parent.text
						end
						wan_addr = @status_iframe.b(:id => @ts_tag_wan_ip).parent.text
						wan_addr =~@ts_tag_ip_regxp
						@tc_wan_ip = Regexp.last_match(1)
						puts "WAN状态显示获取的IP地址为：#{@tc_wan_ip}".to_gbk

						wan_type =~/(#{@tc_wire_mode})/
						puts "WAN状态显示接入类型为：#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, 'dhcp获取ip地址失败！'
						assert_match /#{@tc_wire_mode}/, wan_type, '接入类型错误！'

						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
				}

				operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值，查看页面显示的远程管理地址信息是否准确；") {
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")
						#系统设置
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name==@tc_select_state
								system_set.click
						end
						#外网访问WEB
						web_remote = @advance_iframe.link(id: @ts_tag_op_remote)
						unless web_remote.parent.text==@tc_tag_liclass
								web_remote.click
						end
						#打开外网访问WEB功能
						button_off = @advance_iframe.button(class_name: @tc_tag_button_off)
						if button_off.exists?
								button_off.click
						end
						button_on = @advance_iframe.button(class_name: @tc_tag_button_on)
						assert(button_on.exists?, "打开外网访问失败!")
						@advance_iframe.button(id: @ts_tag_sbm).click
						sleep @tc_remote_time
						@tc_remote_port = @advance_iframe.text_field(id: @tc_tag_port).value
				}

				operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面（注意登录认证对话框等显示字符的合法/正确性，如不能显示异常字符图片或不符合当前客户的字符图片）；") {
						remote_url = "#{@tc_wan_ip}:#{@tc_remote_port}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						assert(rs, "远程WEB访问失败!")
				}

				operate("4、测试网上另一台主机PC3通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {
						#pending
				}

				operate("5、PC2通过WAN口IP地址+非设置的远程访问端口号是否能访问到DUT的WEB管理页面。") {
						remote_url = "#{@tc_wan_ip}:#{@tc_remote_port.succ!}"
						puts "Remote Web Login :#{remote_url}"
						rs=@tc_server_obj.login_router(remote_url, @ts_default_usr, @ts_default_pw)
						refute(rs, "错误的端口也能远程WEB访问!")
				}

		end

		def clearup

				operate("1 关闭外网访问WEB功能") {
						if !@advance_iframe.nil? && !@advance_iframe.exists?
								@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								@browser.link(id: @ts_tag_options).click
								@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						end
						#系统设置
						system_set = @advance_iframe.link(id: @ts_tag_op_system)
						unless system_set.class_name==@tc_select_state
								system_set.click
						end
						#外网访问WEB
						web_remote = @advance_iframe.link(id: @ts_tag_op_remote)
						unless web_remote.parent.text==@tc_tag_liclass
								web_remote.click
						end
						#打开外网访问WEB功能
						button_on = @advance_iframe.button(class_name: @tc_tag_button_on)
						if button_on.exists?
								button_on.click
								@advance_iframe.button(id: @ts_tag_sbm).click
								sleep @tc_remote_time
						end
				}
		end

}
