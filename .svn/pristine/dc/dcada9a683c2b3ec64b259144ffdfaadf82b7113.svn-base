#encoding:utf-8
#router system info page tags
#author:wuhongliang
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject
		module WIFI_Page
				include PageObject
				in_iframe(src: @@ts_tag_wifiset) do |frame|
						#ssid 设置
						link(:wifi_basic, id: @@ts_tag_wifi_basic, frame: frame)
						#高级设置
						link(:wifi_adv, id: @@ts_tag_wifi_advance, frame: frame)
						#basic
						radio_button(:wifi_2g, id: @@ts_tag_radio_basic, frame: frame)
						radio_button(:wifi_5g, id: @@ts_tag_radio_basic_5g, frame: frame)
						#adv
						radio_button(:wifi_adv_2g, id: @@ts_tag_radio_adv, frame: frame)
						radio_button(:wifi_adv_5g, id: @@ts_tag_radio_adv_5g, frame: frame)
						#set ssid
						text_field(:ssid1, id: @@ts_tag_wifi_ssid1, frame: frame)
						text_field(:ssid2, id: @@ts_tag_wifi_ssid2, frame: frame)
						text_field(:ssid3, id: @@ts_tag_wifi_ssid3, frame: frame)
						text_field(:ssid4, id: @@ts_tag_wifi_ssid4, frame: frame)
						text_field(:ssid5, id: @@ts_tag_wifi_ssid5, frame: frame)
						text_field(:ssid6, id: @@ts_tag_wifi_ssid6, frame: frame)
						text_field(:ssid7, id: @@ts_tag_wifi_ssid7, frame: frame)
						text_field(:ssid8, id: @@ts_tag_wifi_ssid8, frame: frame)
						#set ssid 5G
						text_field(:ssid1_5g, id: @@ts_tag_wifi_ssid1_5g, frame: frame)
						text_field(:ssid2_5g, id: @@ts_tag_wifi_ssid2_5g, frame: frame)
						text_field(:ssid3_5g, id: @@ts_tag_wifi_ssid3_5g, frame: frame)
						text_field(:ssid4_5g, id: @@ts_tag_wifi_ssid4_5g, frame: frame)
						text_field(:ssid5_5g, id: @@ts_tag_wifi_ssid5_5g, frame: frame)
						text_field(:ssid6_5g, id: @@ts_tag_wifi_ssid6_5g, frame: frame)
						text_field(:ssid7_5g, id: @@ts_tag_wifi_ssid7_5g, frame: frame)
						text_field(:ssid8_5g, id: @@ts_tag_wifi_ssid8_5g, frame: frame)
						#set pw mode
						select_list(:ssid1_pwmode, id: @@ts_tag_pw_mode1, frame: frame)
						select_list(:ssid2_pwmode, id: @@ts_tag_pw_mode2, frame: frame)
						select_list(:ssid3_pwmode, id: @@ts_tag_pw_mode3, frame: frame)
						select_list(:ssid4_pwmode, id: @@ts_tag_pw_mode4, frame: frame)
						select_list(:ssid5_pwmode, id: @@ts_tag_pw_mode5, frame: frame)
						select_list(:ssid6_pwmode, id: @@ts_tag_pw_mode6, frame: frame)
						select_list(:ssid7_pwmode, id: @@ts_tag_pw_mode7, frame: frame)
						select_list(:ssid8_pwmode, id: @@ts_tag_pw_mode8, frame: frame)
						#set pw mode 5g
						select_list(:ssid1_pwmode_5g, id: @@ts_tag_pw_mode1_5g, frame: frame)
						select_list(:ssid2_pwmode_5g, id: @@ts_tag_pw_mode2_5g, frame: frame)
						select_list(:ssid3_pwmode_5g, id: @@ts_tag_pw_mode3_5g, frame: frame)
						select_list(:ssid4_pwmode_5g, id: @@ts_tag_pw_mode4_5g, frame: frame)
						select_list(:ssid5_pwmode_5g, id: @@ts_tag_pw_mode5_5g, frame: frame)
						select_list(:ssid6_pwmode_5g, id: @@ts_tag_pw_mode6_5g, frame: frame)
						select_list(:ssid7_pwmode_5g, id: @@ts_tag_pw_mode7_5g, frame: frame)
						select_list(:ssid8_pwmode_5g, id: @@ts_tag_pw_mode8_5g, frame: frame)
						#set passwd
						text_field(:ssid1_pw, id: @@ts_tag_wifi_pw1, frame: frame)
						text_field(:ssid2_pw, id: @@ts_tag_wifi_pw2, frame: frame)
						text_field(:ssid3_pw, id: @@ts_tag_wifi_pw3, frame: frame)
						text_field(:ssid4_pw, id: @@ts_tag_wifi_pw4, frame: frame)
						text_field(:ssid5_pw, id: @@ts_tag_wifi_pw5, frame: frame)
						text_field(:ssid6_pw, id: @@ts_tag_wifi_pw6, frame: frame)
						text_field(:ssid7_pw, id: @@ts_tag_wifi_pw7, frame: frame)
						text_field(:ssid8_pw, id: @@ts_tag_wifi_pw8, frame: frame)
						#set passwd 5g
						text_field(:ssid1_pw_5g, id: @@ts_tag_wifi_pw1_5g, frame: frame)
						text_field(:ssid2_pw_5g, id: @@ts_tag_wifi_pw2_5g, frame: frame)
						text_field(:ssid3_pw_5g, id: @@ts_tag_wifi_pw3_5g, frame: frame)
						text_field(:ssid4_pw_5g, id: @@ts_tag_wifi_pw4_5g, frame: frame)
						text_field(:ssid5_pw_5g, id: @@ts_tag_wifi_pw5_5g, frame: frame)
						text_field(:ssid6_pw_5g, id: @@ts_tag_wifi_pw6_5g, frame: frame)
						text_field(:ssid7_pw_5g, id: @@ts_tag_wifi_pw7_5g, frame: frame)
						text_field(:ssid8_pw_5g, id: @@ts_tag_wifi_pw8_5g, frame: frame)
						#set link num
						text_field(:ssid1_link, id: @@ts_tag_wifi_linknum1, frame: frame)
						text_field(:ssid2_link, id: @@ts_tag_wifi_linknum2, frame: frame)
						text_field(:ssid3_link, id: @@ts_tag_wifi_linknum3, frame: frame)
						text_field(:ssid4_link, id: @@ts_tag_wifi_linknum4, frame: frame)
						text_field(:ssid5_link, id: @@ts_tag_wifi_linknum5, frame: frame)
						text_field(:ssid6_link, id: @@ts_tag_wifi_linknum6, frame: frame)
						text_field(:ssid7_link, id: @@ts_tag_wifi_linknum7, frame: frame)
						text_field(:ssid8_link, id: @@ts_tag_wifi_linknum8, frame: frame)
						#set link num 5g
						text_field(:ssid1_link_5g, id: @@ts_tag_wifi_linknum1_5g, frame: frame)
						text_field(:ssid2_link_5g, id: @@ts_tag_wifi_linknum2_5g, frame: frame)
						text_field(:ssid3_link_5g, id: @@ts_tag_wifi_linknum3_5g, frame: frame)
						text_field(:ssid4_link_5g, id: @@ts_tag_wifi_linknum4_5g, frame: frame)
						text_field(:ssid5_link_5g, id: @@ts_tag_wifi_linknum5_5g, frame: frame)
						text_field(:ssid6_link_5g, id: @@ts_tag_wifi_linknum6_5g, frame: frame)
						text_field(:ssid7_link_5g, id: @@ts_tag_wifi_linknum7_5g, frame: frame)
						text_field(:ssid8_link_5g, id: @@ts_tag_wifi_linknum8_5g, frame: frame)
						#set wifi switch
						select_list(:ssid1_sw, id: @@ts_tag_wifi_sw1, frame: frame)
						select_list(:ssid2_sw, id: @@ts_tag_wifi_sw2, frame: frame)
						select_list(:ssid3_sw, id: @@ts_tag_wifi_sw3, frame: frame)
						select_list(:ssid4_sw, id: @@ts_tag_wifi_sw4, frame: frame)
						select_list(:ssid5_sw, id: @@ts_tag_wifi_sw5, frame: frame)
						select_list(:ssid6_sw, id: @@ts_tag_wifi_sw6, frame: frame)
						select_list(:ssid7_sw, id: @@ts_tag_wifi_sw7, frame: frame)
						select_list(:ssid8_sw, id: @@ts_tag_wifi_sw8, frame: frame)
						#set wifi switch 5g
						select_list(:ssid1_sw_5g, id: @@ts_tag_wifi_sw1_5g, frame: frame)
						select_list(:ssid2_sw_5g, id: @@ts_tag_wifi_sw2_5g, frame: frame)
						select_list(:ssid3_sw_5g, id: @@ts_tag_wifi_sw3_5g, frame: frame)
						select_list(:ssid4_sw_5g, id: @@ts_tag_wifi_sw4_5g, frame: frame)
						select_list(:ssid5_sw_5g, id: @@ts_tag_wifi_sw5_5g, frame: frame)
						select_list(:ssid6_sw_5g, id: @@ts_tag_wifi_sw6_5g, frame: frame)
						select_list(:ssid7_sw_5g, id: @@ts_tag_wifi_sw7_5g, frame: frame)
						select_list(:ssid8_sw_5g, id: @@ts_tag_wifi_sw8_5g, frame: frame)
						#2.4G sw
						button(:wifi_sw, id: @@ts_tag_wifi_switch, frame: frame)
						#5G
						button(:wifi_sw_5g, id: @@ts_tag_wifi_switch_5g, frame: frame)
						#signal strenthen
						select_list(:wifi_signal, id: @@ts_tag_rsi, frame: frame)
						select_list(:wifi_signal_5g, id: @@ts_tag_rsi_5g, frame: frame) #5g
						#wifi channel
						select_list(:wifi_channel, id: @@ts_tag_wifichannel, frame: frame)
						select_list(:wifi_channel_5g, id: @@ts_tag_wifichannel_5g, frame: frame) #5g
						button(:save_wifi, id: @@ts_tag_sbm, frame: frame) #save button
						paragraph(:wifi_error, id: @@ts_tag_err_msg, frame: frame)

						link(:close_wifi, class_name: @@ts_tag_aui_close, text: @@ts_tag_aui_clsignal) #close wifi page
				end

		end

		class WIFIPage<MainPage
				include WIFI_Page
				#打开WIFI页面
				def open_wifi_page(url)
						# self.navigate_to url
						self.refresh
						sleep 2
						5.times do
								if advance? && !(sys_version.slice(/系统版本:(.+)/, 1).nil?)
										self.wifi_span_obj.click
										sleep 8
										break if wifi_basic?
								end
								self.clear_cookies
								self.refresh
								sleep 2
								login_with(@@ts_default_usr, @@ts_default_pw, url)
						end
				end

				#关闭无线设置界面
				def close_wifi_page
						self.close_wifi if self.close_wifi?
				end

				#选择wifi设置
				def select_wifi_basic
						unless self.wifi_basic_element.class_name=~/selected/
								self.wifi_basic
								sleep 2
						end
				end

				#选择wifi高级设置
				def select_wifi_adv
						unless self.wifi_adv_element.class_name=~/selected/
								self.wifi_adv
								sleep 2
						end
				end

				#选择2G网络
				def select_2g
						unless self.wifi_2g_selected?
								self.select_wifi_2g
								sleep 1
						end
				end

				#选择5G网络
				def select_5g
						if self.wifi_5g?
								unless self.wifi_5g_selected?
										self.select_wifi_5g
										sleep 1
								end
						else
								puts "Not support 5G!"
						end
				end

				#SSID设置->选择2.4g
				def select_2g_set
						select_wifi_basic
						select_2g
				end

				#5G基础设置
				def select_5g_set
						select_wifi_basic
						select_5g
				end

				#打开WIFI设置->SSID设置->选择2.4g
				def select_2g_basic(url)
						open_wifi_page(url)
						select_2g_set
				end

				#选择5G基础设置
				def select_5g_basic(url)
						open_wifi_page(url)
						select_5g_set
				end

				#2G高级设置
				def select_2g_adv
						unless wifi_adv_2g_selected?
								self.select_wifi_2g
						end
				end

				#5G高级设置
				def select_5g_adv
						if wifi_adv_5g?
								unless wifi_adv_5g_selected?
										select_wifi_adv_5g
								end
						else
								puts "Not support 5G!"
						end
				end

				#无线高级设置-选择2.4G
				def select_2g_advset
						select_wifi_adv
						select_2g_adv
				end

				#无线高级设置-选择5G
				def select_5g_advset
						select_wifi_adv
						select_5g_adv
				end

				#无线设置-选择高级设置-选中2.4G
				def select_2g_advance(url)
						open_wifi_page(url)
						select_2g_advset
				end

				#无线设置-选择高级设置-选中5G
				def select_5g_advance(url)
						open_wifi_page(url)
						select_5g_advset
				end

				#保存wifis配置,正确的无线配置输入后，保存时要等待约20s
				def save_wifi_config(time=65)
						self.save_wifi
						puts "sleeping #{time} seconds for saving config..."
						sleep time
						unless self.ssid1?
								refresh
								sleep 1
								refresh
								self.wifi_span_obj.click #再次打开wifi设置界面
								sleep 8
						end
				end

				#设置wpa模式
				def set_ssid1_wpa
						unless self.ssid1_pwmode==@@ts_sec_mode_wpa
								self.ssid1_pwmode = @@ts_sec_mode_wpa
								true
						else
								false
						end
				end

				def set_ssid2_wpa
						unless self.ssid2_pwmode==@@ts_sec_mode_wpa
								self.ssid2_pwmode = @@ts_sec_mode_wpa
						end
				end

				def set_ssid3_wpa
						unless self.ssid3_pwmode==@@ts_sec_mode_wpa
								self.ssid3_pwmode = @@ts_sec_mode_wpa
						end
				end

				def set_ssid4_wpa
						unless self.ssid4_pwmode==@@ts_sec_mode_wpa
								self.ssid4_pwmode = @@ts_sec_mode_wpa
						end
				end

				def set_ssid5_wpa
						unless self.ssid5_pwmode==@@ts_sec_mode_wpa
								self.ssid5_pwmode = @@ts_sec_mode_wpa
						end
				end

				def set_ssid6_wpa
						unless self.ssid6_pwmode==@@ts_sec_mode_wpa
								self.ssid6_pwmode = @@ts_sec_mode_wpa
						end
				end

				def set_ssid7_wpa
						unless self.ssid7_pwmode==@@ts_sec_mode_wpa
								self.ssid7_pwmode = @@ts_sec_mode_wpa
						end
				end

				def set_ssid8_wpa
						unless self.ssid8_pwmode==@@ts_sec_mode_wpa
								self.ssid8_pwmode = @@ts_sec_mode_wpa
						end
				end

				#5G WPA
				def set_ssid1_wpa_5g
						unless self.ssid1_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid1_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid2_wpa_5g
						unless self.ssid2_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid2_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid3_wpa_5g
						unless self.ssid3_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid3_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid4_wpa_5g
						unless self.ssid4_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid4_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid5_wpa_5g
						unless self.ssid5_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid5_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid6_wpa_5g
						unless self.ssid6_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid6_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid7_wpa_5g
						unless self.ssid7_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid7_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				def set_ssid8_wpa_5g
						unless self.ssid8_pwmode_5g==@@ts_sec_mode_wpa
								self.ssid8_pwmode_5g = @@ts_sec_mode_wpa
						end
				end

				#设置none模式
				def set_ssid1_open
						unless self.ssid1_pwmode==@@ts_tag_wifiopen
								self.ssid1_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid2_open
						unless self.ssid2_pwmode==@@ts_tag_wifiopen
								self.ssid2_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid3_open
						unless self.ssid3_pwmode==@@ts_tag_wifiopen
								self.ssid3_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid4_open
						unless self.ssid4_pwmode==@@ts_tag_wifiopen
								self.ssid4_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid5_open
						unless self.ssid5_pwmode==@@ts_tag_wifiopen
								self.ssid5_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid6_open
						unless self.ssid6_pwmode==@@ts_tag_wifiopen
								self.ssid6_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid7_open
						unless self.ssid7_pwmode==@@ts_tag_wifiopen
								self.ssid7_pwmode = @@ts_tag_wifiopen
						end
				end

				def set_ssid8_open
						unless self.ssid8_pwmode==@@ts_tag_wifiopen
								self.ssid8_pwmode = @@ts_tag_wifiopen
						end
				end

				#设置none模式 5G
				def set_ssid1_open_5g
						unless self.ssid1_pwmode_5g==@@ts_tag_wifiopen
								self.ssid1_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid2_open_5g
						unless self.ssid2_pwmode_5g==@@ts_tag_wifiopen
								self.ssid2_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid3_open_5g
						unless self.ssid3_pwmode_5g==@@ts_tag_wifiopen
								self.ssid3_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid4_open_5g
						unless self.ssid4_pwmode_5g==@@ts_tag_wifiopen
								self.ssid4_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid5_open_5g
						unless self.ssid5_pwmode_5g==@@ts_tag_wifiopen
								self.ssid5_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid6_open_5g
						unless self.ssid6_pwmode_5g==@@ts_tag_wifiopen
								self.ssid6_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid7_open_5g
						unless self.ssid7_pwmode_5g==@@ts_tag_wifiopen
								self.ssid7_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				def set_ssid8_open_5g
						unless self.ssid8_pwmode_5g==@@ts_tag_wifiopen
								self.ssid8_pwmode_5g = @@ts_tag_wifiopen
						end
				end

				#修改ssid1密码
				def modify_ssid1_pw(pw)
						rs_mode = set_ssid1_wpa
						sleep 1
						ssid1_pw1 = self.ssid1_pw
						if ssid1_pw1 != pw
								self.ssid1_pw_element.click
								self.ssid1_pw = pw
								true
						elsif rs_mode
								true
						else
								false
						end
				end

				def modify_ssid2_pw(pw)
						set_ssid2_wpa
						sleep 1
						self.ssid2_pw_element.click
						self.ssid2_pw = pw
				end

				def modify_ssid3_pw(pw)
						set_ssid3_wpa
						sleep 1
						self.ssid3_pw_element.click
						self.ssid3_pw = pw
				end

				def modify_ssid4_pw(pw)
						set_ssid4_wpa
						sleep 1
						self.ssid4_pw_element.click
						self.ssid4_pw = pw
				end

				def modify_ssid5_pw(pw)
						set_ssid5_wpa
						sleep 1
						self.ssid5_pw_element.click
						self.ssid5_pw = pw
				end

				def modify_ssid6_pw(pw)
						set_ssid6_wpa
						sleep 1
						self.ssid6_pw_element.click
						self.ssid6_pw = pw
				end

				def modify_ssid7_pw(pw)
						set_ssid7_wpa
						sleep 1
						self.ssid7_pw_element.click
						self.ssid7_pw = pw
				end

				def modify_ssid8_pw(pw)
						set_ssid8_wpa
						sleep 1
						self.ssid8_pw_element.click
						self.ssid8_pw = pw
				end


				#修改ssid1密码 5G
				def modify_ssid1_pw_5g(pw)
						set_ssid1_wpa_5g
						sleep 1
						self.ssid1_pw_5g_element.click
						self.ssid1_pw_5g = pw
				end

				def modify_ssid2_pw_5g(pw)
						set_ssid2_wpa_5g
						sleep 1
						self.ssid2_pw_5g_element.click
						self.ssid2_pw_5g = pw
				end

				def modify_ssid3_pw_5g(pw)
						set_ssid3_wpa_5g
						sleep 1
						self.ssid3_pw_5g_element.click
						self.ssid3_pw_5g = pw
				end

				def modify_ssid4_pw_5g(pw)
						set_ssid4_wpa_5g
						sleep 1
						self.ssid4_pw_5g_element.click
						self.ssid4_pw_5g = pw
				end

				def modify_ssid5_pw_5g(pw)
						set_ssid5_wpa_5g
						sleep 1
						self.ssid5_pw_5g_element.click
						self.ssid5_pw_5g = pw
				end

				def modify_ssid6_pw_5g(pw)
						set_ssid6_wpa_5g
						sleep 1
						self.ssid6_pw_5g_element.click
						self.ssid6_pw_5g = pw
				end

				def modify_ssid7_pw_5g(pw)
						set_ssid7_wpa_5g
						sleep 1
						self.ssid7_pw_5g_element.click
						self.ssid7_pw_5g = pw
				end

				def modify_ssid8_pw_5g(pw)
						set_ssid8_wpa_5g
						sleep 1
						self.ssid8_pw_5g_element.click
						self.ssid8_pw_5g = pw
				end

				#修改ssid1
				def modify_ssid1(ssid)
						self.ssid1_element.click
						self.ssid1 = ssid
				end

				def modify_ssid2(ssid)
						self.ssid2_element.click
						self.ssid2 = ssid
				end

				def modify_ssid3(ssid)
						self.ssid3_element.click
						self.ssid3 = ssid
				end

				def modify_ssid4(ssid)
						self.ssid4_element.click
						self.ssid4 = ssid
				end

				def modify_ssid5(ssid)
						self.ssid5_element.click
						self.ssid5 = ssid
				end

				def modify_ssid6(ssid)
						self.ssid6_element.click
						self.ssid6 = ssid
				end

				def modify_ssid7(ssid)
						self.ssid7_element.click
						self.ssid7 = ssid
				end

				def modify_ssid8(ssid)
						self.ssid8_element.click
						self.ssid8 = ssid
				end

				#修改ssid1 5G
				def modify_ssid1_5g(ssid)
						self.ssid1_5g_element.click
						self.ssid1_5g = ssid
				end

				def modify_ssid2_5g(ssid)
						self.ssid2_5g_element.click
						self.ssid2_5g= ssid
				end

				def modify_ssid3_5g(ssid)
						self.ssid3_5g_element.click
						self.ssid3_5g = ssid
				end

				def modify_ssid4_5g(ssid)
						self.ssid4_5g_element.click
						self.ssid4_5g = ssid
				end

				def modify_ssid5_5g(ssid)
						self.ssid5_5g_element.click
						self.ssid5_5g = ssid
				end

				def modify_ssid6_5g(ssid)
						self.ssid6_5g_element.click
						self.ssid6_5g = ssid
				end

				def modify_ssid7_5g(ssid)
						self.ssid7_5g_element.click
						self.ssid7_5g = ssid
				end

				def modify_ssid8_5g(ssid)
						self.ssid8_5g_element.click
						self.ssid8_5g = ssid
				end

				#设置连接数
				def modify_ssid1_linknum(num)
						self.ssid1_link_element.click
						self.ssid1_link=num
				end

				def modify_ssid2_linknum(num)
						self.ssid2_link_element.click
						self.ssid2_link=num
				end

				def modify_ssid3_linknum(num)
						self.ssid3_link_element.click
						self.ssid3_link=num
				end

				def modify_ssid4_linknum(num)
						self.ssid4_link_element.click
						self.ssid4_link=num
				end

				def modify_ssid5_linknum(num)
						self.ssid5_link_element.click
						self.ssid5_link=num
				end

				def modify_ssid6_linknum(num)
						self.ssid6_link_element.click
						self.ssid6_link=num
				end

				def modify_ssid7_linknum(num)
						self.ssid7_link_element.click
						self.ssid7_link=num
				end

				def modify_ssid8_linknum(num)
						self.ssid8_link_element.click
						self.ssid8_link=num
				end

				#设置连接数5G
				def modify_ssid1_linknum_5g(num)
						self.ssid1_link_5g_element.click
						self.ssid1_link_5g=num
				end

				def modify_ssid2_linknum_5g(num)
						self.ssid2_link_5g_element.click
						self.ssid2_link_5g=num
				end

				def modify_ssid3_linknum_5g(num)
						self.ssid3_link_5g_element.click
						self.ssid3_link_5g=num
				end

				def modify_ssid4_linknum_5g(num)
						self.ssid4_link_5g_element.click
						self.ssid4_link_5g=num
				end

				def modify_ssid5_linknum_5g(num)
						self.ssid5_link_5g_element.click
						self.ssid5_link_5g=num
				end

				def modify_ssid6_linknum_5g(num)
						self.ssid6_link_5g_element.click
						self.ssid6_link_5g=num
				end

				def modify_ssid7_linknum_5g(num)
						self.ssid7_link_5g_element.click
						self.ssid7_link_5g=num
				end

				def modify_ssid8_linknum_5g(num)
						self.ssid8_link_5g_element.click
						self.ssid8_link_5g=num
				end

				#修改ssid1密码并保存
				def change_ssid1_pw(pw, url)
						open_wifi_page(url)
						select_2g_set
						modify_ssid1_pw(pw)
						save_wifi_config
				end

				#修改ssid1并保存
				def change_ssid1(ssid, url)
						open_wifi_page(url)
						select_2g_set
						modify_ssid1(ssid)
						save_wifi_config
				end

				#打开2.4G wifi开关
				def turn_on_2g_sw
						unless self.wifi_sw_element.class_name==@@ts_tag_btn_on
								self.wifi_sw
						end
				end

				# 无线设置-选择高级设置-选中2.4G-打开无线开关
				def open_2g_sw(url)
						select_2g_advance(url)
						turn_on_2g_sw
				end

				#关闭无线开关
				def turn_off_2g_sw
						if self.wifi_sw_element.class_name==@@ts_tag_btn_on
								self.wifi_sw
						end
				end

				# 无线设置-选择高级设置-选中2.4G-关闭无线开关
				def close_2g_sw(url)
						select_2g_advance(url)
						turn_off_2g_sw
				end

				#修改ssid，模式，密码
				def modify_ssid_mode_pwd(url, ssid="Wireless0", pw=@@ts_default_wlan_pw)
						mac_last = get_mac_last
						sleep 1
						open_wifi_page(url)
						flag          = modify_ssid1_pw(pw)
						cur_ssid1     = ssid1
						tc_ssid1_name = "#{ssid}_#{mac_last}"
						unless cur_ssid1 == tc_ssid1_name
								self.ssid1 = tc_ssid1_name
								puts "修改SSID1名为：#{tc_ssid1_name}".encode("GBK")
								flag = true
						end
						save_wifi_config if flag #保存
						fail "修改ssid及密码后，wifi设置界面跳转失败！" unless ssid1?
						puts "Dut ssid: #{ssid1},passwd:#{ssid1_pw},mode:#{ssid1_pwmode}"
						return {:ssid => ssid1, :pwd => ssid1_pw, :mode => ssid1_pwmode}
				end

				#恢复默认ssid
				def modify_default_ssid(url, ssid = "Wireless0")
						open_wifi_page(url)
						tc_ssid1_name = ssid1
						#判断加密方式是否为WPA,如果不是则设置为WPA
						flag          = modify_ssid1_pw(@@ts_default_wlan_pw)
						unless tc_ssid1_name == ssid
								self.ssid1 = ssid
								puts "恢复默认SSID1名为：#{ssid}".encode("GBK")
								flag = true
						end
						save_wifi_config if flag
				end

				#修改信号强度
				def modify_wifi_signal(str)
						wifi_signal_element.select(/#{str}/)
				end
		end
end
