#artDialog X问题
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
		attr = {"id" => "ZLBF_6.1.40", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time        = 3
				@tc_pptpset_time     = 5
				@tc_pptp_time        = 30
				@tc_net_time         = 50
				@tc_tag_advance_div  = "aui_state_lock aui_state_focus" #focus在后表示选中了当前div
				@tc_tag_style_zindex = "z-index"

		end

		def process

				operate("1 打开options设置") {
						option = @browser.link(:id => @ts_tag_options)
						option.click
						@advance_iframe = @browser.iframe(src: @ts_tag_advance_src)
						assert(@advance_iframe.exists?, "打开高级设置失败!")
				}

				operate("2 选择PPTP连接方式") {
						#选择网络连接
						network = @advance_iframe.link(:id, @ts_tag_op_network)
						unless network.class_name =~ /#{@ts_tag_select_state}/
								network.click
								sleep @tc_wait_time
						end
						@advance_iframe.link(:id, @ts_tag_op_pptp).click
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).wait_until_present(@tc_pptpset_time)
				}

				operate("3 设置PPTP参数") {
						puts "PPTP Server:#{@ts_pptp_server_ip}"
						puts "PPTP User:#{@ts_pptp_usr}"
						puts "PPTP PassWD:#{@ts_pptp_pw}"
						@advance_iframe.text_field(:id, @ts_tag_pptp_server).set(@ts_pptp_server_ip)
						@advance_iframe.text_field(:id, @ts_tag_pptp_usr).set(@ts_pptp_usr)
						@advance_iframe.text_field(:id, @ts_tag_pptp_pw).set(@ts_pptp_pw)
						@advance_iframe.button(:id, @ts_tag_sbm).click
						Watir::Wait.until(@tc_wait_time, "PPTP设置成功提示未出现") {
								@pptp_tip=@advance_iframe.div(class_name: @ts_tag_reset, text: /#{@ts_tag_pptp_set}/)
								@pptp_tip.present?
						}
						Watir::Wait.while(@tc_pptp_time, "PPTP设置成功提示消失") {
								@pptp_tip.present?
						}
						puts "Waiting for pptp connection..."
						sleep @tc_pptp_time #路由器网络可能还在重启，这里增加延迟
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
				}

				operate("4 查看WAN状态") {
						@browser.span(:id => @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(:id => @ts_tag_status).click
						@status_iframe = @browser.iframe(src: @tag_status_iframe_src)
						assert(@status_iframe.exists?, '打开WAN状态失败！')
						wan_addr = @status_iframe.b(id: @ts_tag_wan_ip).parent.text
						@ts_tag_ip_regxp=~wan_addr
						puts "PPTP获取的IP地址为：#{Regexp.last_match(1)}".to_gbk

						wan_type = @status_iframe.b(id: @ts_tag_wan_type).parent.text
						/(#{@ts_wan_mode_pptp})/=~wan_type
						puts "查询到接入类型为：#{Regexp.last_match(1)}".to_gbk

						mask     = @status_iframe.b(id: @ts_tag_wan_mask).parent.text
						dns_addr = @status_iframe.b(id: @ts_tag_wan_dns).parent.text
						@ts_tag_ip_regxp=~dns_addr
						puts "PPTP获取的DNS地址为：#{Regexp.last_match(1)}".to_gbk

						assert_match @ts_tag_ip_regxp, wan_addr, 'PPTP获取ip地址失败！'
						assert_match /#{@ts_wan_mode_pptp}/, wan_type, '接入类型错误！'
						assert_match @ts_tag_ip_regxp, mask, 'PPTP获取ip地址掩码失败！'
						assert_match @ts_tag_ip_regxp, dns_addr, 'PPTP获取dns ip地址失败！'

				}

				operate("5 验证业务") {
						rs =ping(@ts_web)
						assert(rs, '无法连接网络')
				}
		end

		def clearup

				operate("1 恢复为默认的接入方式，DHCP接入") {
						if @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.span(:id => @ts_tag_netset).exists?
								login_recover(@browser, @ts_default_ip)
						end

						@browser.span(:id => @ts_tag_netset).click
						@wan_iframe = @browser.iframe(src: @ts_tag_netset_src)
						#设置wan连接方式为网线连接
						flag        = false
						#设置wan连接方式为网线连接
						rs1         = @wan_iframe.link(:id => @ts_tag_wired_mode_link)
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
								sleep @tc_net_time
						end
				}
		end

}
