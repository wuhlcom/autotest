#
#description:
# 这里测试基本状态不包括信道
#author:wuhongliang
#date:2015-06-30 14:12:40
#modify:
#
testcase {
		attr = {"id" => "ZLBF_5.1.24", "level" => "P1", "auto" => "n"}

		def prepare
				@tc_wait_time          = 2
				@tc_status_time        = 5
				@tc_channelset_time    = 10
				@tc_channelchange_time = 30
				@tc_net_time           = 50
				@tc_tag_adsave_cont    = "aui_content"
				@tc_ssid1              = "zhilu_autossid1"
				@tc_ssid2              = "zhilu_autossid2"
				@tc_none_value         = "NONE"
				@tc_systatus_none      = "NONE"
				@ts_sec_mode_wpa       = 'WPA-PSK/WPA2-PSK'
				@tc_wpa_value          = "WPAPSKWPA2PSK"
				@tc_tag_checkbox       = "pwdshow"
				@tc_tag_on_off         = "WIRELESS-ONOFF"
				@tc_tag_on             = "On"
				@ts_tag_ssid_name      = "WIRELESS-SSID"
				@tc_tag_wifi_encryption= "WIRELESS-ENCRY"
				@tc_tag_wifi_channel   = "WIRELESS-CH"

				@tc_tag_wifiset           = "wifi_advance.asp"
				@tc_tag_liclass           = "active"
				@tc_tag_selected_status   = "selected"
				@tc_tag_wifi_channel_list = "sz11gChannel"
				@tc_channel_value         = "9"
				@tc_channel               = "2452MHz (Channel 9)"

		end

		def process

				operate("1 打开网络连接设置") {
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						assert_match /#{@ts_tag_lan_src}/i, @lan_iframe.src, "打开内网设置失败!"
				}

				operate("2 修改WIFI加密码方式为#{@ts_sec_mode_none}") {
						@tc_default_ssid = @lan_iframe.text_field(:id, @ts_tag_ssid).value
						puts "当前路由的SSID为:#{@tc_default_ssid}".to_gbk
						puts "修改SSID为：#{@tc_ssid1}".to_gbk
						ssid_obj = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_ssid1)
						puts "修改加密方式为：#{@ts_sec_mode_none}".to_gbk
						select = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						unless select.selected?(@ts_sec_mode_none)
								select.select(@ts_sec_mode_none)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "sleep #{@tc_net_time} seconds for net reseting..."
						sleep @tc_net_time
				}

				operate("3 修改加密方式为#{@ts_sec_mode_none}后查看无线网络状态") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_status_time, "网络状态窗口未出现") {
								@systatus_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
								@systatus_iframe.present?
						}

						wifi_on_off = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_on_off =~ /(#{@tc_tag_on})$/
						puts "状态页面显示无线状态为：#{Regexp.last_match(1)}".to_gbk

						wifi_ssid = @systatus_iframe.b(:id => @ts_tag_ssid_name).parent.text
						wifi_ssid =~ /(#{@tc_ssid1})$/
						puts "状态页面显示无线SSID为：#{Regexp.last_match(1)}".to_gbk

						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_encryption =~ /(#{@tc_none_value}$)/
						puts "状态页面显示无线加密方式为：#{Regexp.last_match(1)}".to_gbk

						wifi_channel = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text
						wifi_channel =~ /(\d{1,2}$)/
						puts "状态页面显示无线信道为：#{Regexp.last_match(1)}".to_gbk

						assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
						assert_match(/#{@tc_ssid1}$/, wifi_ssid, "SSID显示不正确")
						assert_match(/#{@tc_none_value}$/, wifi_encryption, "加密方式显示错误")
						assert_match(/\d{1,2}$/, wifi_channel, "信道显示错误")
				}

				operate("4 修改WIFI加密码方式为#{@ts_sec_mode_wpa}") {
						if @browser.div(class_name: @ts_aui_state).exists?||@browser.div(class_name: @ts_aui_state_focus).exists?
								@browser.execute_script(@ts_close_div)
						end
						#打开lan设置
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						puts "修改SSID为：#{@tc_ssid2}".to_gbk
						ssid_obj= @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_obj.set(@tc_ssid2)

						puts "修改加密方式为：#{@ts_sec_mode_wpa}".to_gbk
						select       = @lan_iframe.select_list(id: @ts_tag_sec_select_list)
						passwd_input =@lan_iframe.text_field(id: @ts_tag_ssid_pwd)
						unless select.selected?(@ts_sec_mode_wpa)
								select.select(@ts_sec_mode_wpa)
								passwd_input.set(@ts_default_wlan_pw)
						end
						@lan_iframe.button(:id, @ts_tag_sbm).click
						puts "sleep #{@tc_net_time} seconds for net reseting..."
						sleep @tc_net_time
				}

				operate("5  修改信道") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						@browser.refresh #重新刷新
						sleep @tc_wait_time
						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_status_time, "高级设置界面未打开") {
								@browser.iframe(:src, @ts_tag_advance_src).present?
						}
						@advance_iframe = @browser.iframe(:src, @ts_tag_advance_src)
						#选择网络设置
						networking      = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						#选择无线设置
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						#
						channel_select      = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						@tc_default_channel = channel_select.selected_options[0].text
						unless channel_select.selected?(@tc_channel)
								channel_select.select(@tc_channel)
								sleep 1
								@advance_iframe.button(id: @ts_tag_sbm).click
								puts "change channel to #{@tc_channel} "

								Watir::Wait.while(@tc_channelset_time, "等待保存配置提示消失".to_gbk) {
										advance_save_cont = @advance_iframe.div(class_name: @tc_tag_adsave_cont)
										advance_save_cont.present?
								}
								#等待上一步修改信道操作生效
								puts "waiting for channel changed..."
								sleep @tc_channelchange_time
						end
				}

				operate("6 修改加密方式为#{@ts_sec_mode_wpa}后查看无线网络状态") {
						#找到共享目录页面根DIV
						file_div         = @browser.div(class_name: @ts_tag_file_div)
						zindex_value     = file_div.style(@ts_tag_style_zindex)
						#找到背景根DIV
						background_zindex=(zindex_value.to_i-1).to_s
						background_div   = @browser.element(xpath: "//div[contains(@style,'#{background_zindex}')]")

						#隐藏共享目录页面根DIV
						@browser.execute_script("$(arguments[0]).hide();", file_div)
						#隐藏背景根DIV
						@browser.execute_script("$(arguments[0]).hide();", background_div)
						@browser.refresh #重新刷新
						sleep @tc_wait_time
						@browser.span(id: @ts_tag_status).wait_until_present(@tc_wait_time)
						@browser.span(id: @ts_tag_status).click
						sleep @tc_wait_time
						Watir::Wait.until(@tc_status_time, "网络状态窗口未出现") {
								@browser.iframe(:src, @ts_tag_status_iframe_src).present?
						}
						@systatus_iframe = @browser.iframe(:src, @ts_tag_status_iframe_src)
						wifi_on_off      = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_on_off =~ /(#{@tc_tag_on})$/
						puts "状态页面显示无线状态为：#{Regexp.last_match(1)}".to_gbk

						wifi_ssid = @systatus_iframe.b(:id => @ts_tag_ssid_name).parent.text
						wifi_ssid =~ /(#{@tc_ssid2})$/
						puts "状态页面显示无线SSID为：#{Regexp.last_match(1)}".to_gbk

						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_encryption =~ /(#{@ts_sec_mode_wpa}$)/
						puts "状态页面显示无线加密方式为：#{Regexp.last_match(1)}".to_gbk

						wifi_channel = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text
						wifi_channel =~ /(\d{1,2}$)/
						puts "状态页面显示无线信道为：#{Regexp.last_match(1)}".to_gbk

						wifi_on_off     = @systatus_iframe.b(:id => @tc_tag_on_off).parent.text
						wifi_ssid       = @systatus_iframe.b(:id => @ts_tag_ssid_name).parent.text
						wifi_encryption = @systatus_iframe.b(:id => @tc_tag_wifi_encryption).parent.text
						wifi_channel    = @systatus_iframe.b(:id => @tc_tag_wifi_channel).parent.text

						assert_match(/#{@tc_tag_on}$/, wifi_on_off, "WIFI状态不正确!")
						assert_match(/#{@tc_ssid2}$/, wifi_ssid, "SSID显示不正确")
						assert_match(/#{@ts_sec_mode_wpa}$/, wifi_encryption, "加密方式显示错误")
						assert_match(/#{@tc_channel_value}$/, wifi_channel, "信道显示错误")
				}

		end

		def clearup

				operate("1 恢复默认加密方式和默认SSID") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end
						unless @browser.span(:id => @ts_tag_lan).exists?
								login_recover(@browser, @ts_default_ip)
						end

						#打开lan设置
						@browser.span(:id => @ts_tag_lan).click
						@lan_iframe = @browser.iframe
						ssid_obj    = @lan_iframe.text_field(:id, @ts_tag_ssid)
						ssid_value  = ssid_obj.value
						puts "当前SSID为#{ssid_value}".to_gbk
						flag = false
						if !@tc_default_ssid.nil? &&(ssid_value!=@tc_default_ssid)
								unless ssid_value==@tc_default_ssid
										puts "修改SSID为默认SSID：#{@tc_default_ssid}".to_gbk
										flag=true
										@lan_iframe.text_field(:id, @ts_tag_ssid).set(@tc_default_ssid)
								end
						end

						unless @lan_iframe.select_list(id: @ts_tag_sec_select_list).selected?(@ts_sec_mode_wpa)
								puts "修改加密方式为默认加密方式：#{@ts_sec_mode_wpa}".to_gbk
								flag=true
								@lan_iframe.select_list(id: @ts_tag_sec_select_list).select(@ts_sec_mode_wpa)
								@lan_iframe.text_field(id: @ts_tag_ssid_pwd).set(@ts_default_wlan_pw)
						end

						if flag
								@lan_iframe.button(:id, @ts_tag_sbm).click
								puts "sleep #{@tc_net_time} second for net reseting..."
								sleep @tc_net_time
						end
				}

				operate("2 恢复默认信道") {
						if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
								@browser.execute_script(@ts_close_div)
						end

						unless @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
								login_recover(@browser, @ts_default_ip)
						end

						@browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
						@browser.link(id: @ts_tag_options).click
						sleep @tc_wait_time
						networking = @advance_iframe.link(id: @ts_tag_op_network)
						unless networking.class_name==@tc_tag_selected_status
								networking.click
						end
						wifiset             = @advance_iframe.link(href: @tc_tag_wifiset)
						wifiset_parent_class=wifiset.parent.class_name
						unless wifiset_parent_class==@tc_tag_liclass
								wifiset.click
						end
						channel_select = @advance_iframe.select_list(id: @tc_tag_wifi_channel_list)
						unless @tc_default_channel.nil?
								unless channel_select.selected?(@tc_default_channel)
										puts "恢复为默认信道：#{@tc_default_channel}".to_gbk
										channel_select.select(@tc_default_channel)
										sleep 1
										@advance_iframe.button(id: @ts_tag_sbm).click
										puts "sleep #{@tc_net_time+20} seconds for net reseting..."
								end
						end
				}
		end

}
