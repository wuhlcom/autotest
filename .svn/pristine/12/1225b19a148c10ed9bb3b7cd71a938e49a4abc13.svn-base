#encoding:utf-8
#
# 路由器高级设置
# author:liluping
# date:2016-03-09
# modify:
#
# file_path1 = File.expand_path('../router_main_page', __FILE__)
# require file_path1
module RouterPageObject
		module Options_Page
				include PageObject
				in_iframe(:src => @@ts_tag_advance_src) do |frame|
						link(:network, id: @@ts_tag_op_network, frame: frame) ###网络设置
						link(:mac_clone, id: @@ts_tag_mac_clone, frame: frame) ##mac克隆
						button(:clone_sw, id: @@ts_tag_clone_sw, frame: frame) #克隆开关
						text_field(:clone_input, id: @@ts_tag_pcmac, frame: frame) #输入克隆地址
						button(:clone_btn, id: @@ts_tag_fillmac, frame: frame) #克隆
						button(:clone_save, id: @@ts_tag_sbm, frame: frame) #保存克隆
						span(:clone_error, id: @@ts_tag_errormsg, frame: frame) #克隆错误提示

						link(:pptp, id: @@ts_tag_op_pptp, frame: frame) ##PPTP设置
						text_field(:pptp_ip, name: @@ts_tag_pptp_server, frame: frame) #服务器ip地址
						text_field(:pptp_user, name: @@ts_tag_pptp_usr, frame: frame) #用户名
						text_field(:pptp_pwd, name: @@ts_tag_pptp_pw, frame: frame) #口令
						button(:pptp_save, id: @@ts_tag_sbm, frame: frame) #保存
						paragraph(:pptp_err_msg, :id => @@ts_tag_err_msg, :frame => frame) #pptp输入错误提示
				end
		end

		class OptionsPage < MainPage
				include Options_Page

				#pptp输入
				def pptp_input(ip, user, pwd)
						self.pptp_ip_element.click
						self.pptp_ip   = ip
						self.pptp_user_element.click
						self.pptp_user = user
						self.pptp_pwd_element.click
						self.pptp_pwd  = pwd
				end

				def select_pptp(url)
						open_options_page(url)
						network_click
						pptp #pptp设置
						sleep 2
				end

				#设置pptp连接
				def set_pptp(ip, user, pwd, url, time=80)
						select_pptp(url)
						pptp_input(ip, user, pwd)
						pptp_save
            puts "sleeping #{time} seconds for net reseting..."
						sleep time
				end

				#打开克隆开关
				def clone_open
						#如果开关是关闭的则打开
						if clone_sw_element.class_name=="off"
								clone_sw
						end
				end

				#关闭克隆开关
				def clone_close
						#如果开关是打开的则关闭
						if clone_sw_element.class_name=="on"
								clone_sw
						end
				end

				#保存克隆
				def save_clone(time = 35)
						clone_save
						puts "sleeping #{time} seconds for saving clone"
						sleep time
				end

				#输入 克隆地址前先选中输入框
				def input_clone_mac(mac)
						self.clone_input_element.click
						self.clone_input=mac
				end

				def select_clone_mac
						network_click #点击网络设置
						sleep 2
						self.mac_clone #点击 MAC克隆
						sleep 2
				end

				#选择高级设置->网络设置->MAC克隆
				def open_mac_clone_page(url)
						open_options_page(url) #打开高级设置
						select_clone_mac
				end

				#高级设置-网络设置->MAC克隆->打开克隆开关,但未点击保存
				def open_mac_clone_sw(url)
						open_mac_clone_page(url)
						clone_open
				end

				#高级设置-网络设置->MAC克隆->关闭克隆开关，但未点击保存
				def close_mac_clone_sw(url)
						open_mac_clone_page(url)
						clone_close
				end

				#关闭克隆开关并保存
				def shutdown_clone(url)
						close_mac_clone_sw(url)
						save_clone
				end

				#打开克隆页面，点击克隆按钮并保存来实现克隆
				def clone_mac(url)
						open_mac_clone_sw(url)
						clone_btn
						sleep 1
						clone_btn #多点击一次
						save_clone
				end

				def clone_input_save(mac)
						input_clone_mac(mac) #输入克隆地址
						save_clone #保存
				end

				#打开克隆页面，输入克隆MAC并保存来实现克隆
				def set_clone_mac(mac, url)
						open_mac_clone_sw(url)
						clone_input_save(mac)
				end

				#打开克隆页面，获取克隆开关状态
				def get_clone_sw_status(url)
						open_mac_clone_page(url)
						clone_sw_element.class_name #克隆开关状态
				end
		end
end















