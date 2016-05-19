#encoding:utf-8
#
# 路由器高级设置
# author:liluping
# date:2016-03-09
# modify:
#

module RouterPageObject
		module Options_Page
				include PageObject
				in_iframe(:src => @@ts_tag_advance_src) do |frame|
						link(:security_settings, id: @@ts_tag_security, frame: frame) ###安全设置
						##防火墙设置
						link(:firewall, id: @@ts_tag_fwset, frame: frame)
						button(:firewall_switch, id: @@ts_tag_security_sw, frame: frame) #防火墙总开关
						button(:ip_filter_switch, id: @@ts_tag_security_ip, frame: frame) #IP过滤总开关
						button(:mac_filter_switch, id: @@ts_tag_security_mac, frame: frame) #MAC过滤总开关
						button(:url_filter_switch, id: @@ts_tag_security_url, frame: frame) #URL过滤总开关
						button(:firewall_save, id: @@ts_tag_security_save, frame: frame) #保存

						##IP过滤
						link(:ip_filter, id: @@ts_ip_set, frame: frame)
						span(:firewall_status, id: @@ts_tag_fwstatus, frame: frame) #防火墙功能状态
						span(:ip_filter_status, id: @@ts_tag_ip_filter_state, frame: frame) #IP过滤功能状态
						span(:ip_add_item, id: @@ts_tag_additem, frame: frame) #添加新条目
						span(:ip_all_valid, id: @@ts_ip_valid, frame: frame) #使所有条目生效
						span(:ip_all_invalid, id: @@ts_ip_invalid, frame: frame) #使所有条目失效
						span(:ip_all_del, id: @@ts_tag_del_ipfilter_btn, frame: frame) #删除所有条目
						text_field(:eff_start_time, id: @@ts_ip_start_time, frame: frame) #生效开始时间
						text_field(:eff_end_time, id: @@ts_ip_end_time, frame: frame) #生效结束时间
						text_field(:eff_start_time1, id: @@ts_ip_start_time1, frame: frame) #编辑后的生效开始时间
						text_field(:eff_end_time1, id: @@ts_ip_end_time1, frame: frame) #编辑后的生效结束时间
						text_field(:src_ip_start, id: @@ts_ip_src, frame: frame) #源开始IP地址
						text_field(:src_ip_end, id: @@ts_ip_src_end, frame: frame) #源结束IP地址
						text_field(:src_port_start, id: @@ts_ip_src_port, frame: frame) #源开始端口
						text_field(:src_port_end, id: @@ts_ip_src_port_end, frame: frame) #源结束端口
						text_field(:dst_ip_start, id: @@ts_ip_dst, frame: frame) #目的开始IP地址
						text_field(:dst_ip_end, id: @@ts_ip_dst_end, frame: frame) #目的结束IP地址
						text_field(:dst_port_start, id: @@ts_ip_dst_port, frame: frame) #目的开始端口
						text_field(:dst_port_end, id: @@ts_ip_dst_port_end, frame: frame) #目的结束端口
						select_list(:ip_protocol_type, id: @@ts_tag_vir_protocol1, frame: frame) #协议
						select_list(:ip_protocol_type1, id: @@ts_tag_vir_protocol, frame: frame) #编辑后的协议
						select_list(:ip_status_type, id: @@ts_tag_vir_status1, frame: frame) #状态
						select_list(:ip_status_type1, id: @@ts_tag_vir_status, frame: frame) #编辑后的状态
						button(:ip_save, id: @@ts_tag_save_filter, frame: frame) #保存
						button(:ip_save1, id: @@ts_tag_save_filter1, frame: frame) #编辑后的保存
						button(:ip_back, id: @@ts_tag_ip_back, frame: frame) #返回
						paragraph(:ip_filter_err_msg, id: @@ts_tag_err_msg, frame: frame) #ip过滤错误提示
						table(:ip_filter_table, id: @@ts_iptable, frame: frame)
						text_field(:dst_port_start1, id: @@ts_ip_dst_port1, frame: frame) #编辑后的目的开始端口
						text_field(:dst_port_end1, id: @@ts_ip_dst_port_end1, frame: frame) #编辑后的目的结束端口
						div(:ip_err_msg, class_name: @@ts_tag_aui_content, frame: frame) #条目超出限制提示
						link(:ip_hint_close, class_name: @@ts_ip_hint_close, frame: frame) #关闭提示信息

						##URL过滤
						link(:url_filter, id: @@ts_url_set, frame: frame)
						select_list(:url_filter_type, id: @@ts_url_black, frame: frame) #类型
						text_field(:url_url, id: @@ts_web_url, frame: frame) #网址
						link(:url_add, class_name: @@ts_tag_addvir, frame: frame) #+
						div(:url_text_b, id: @@ts_tag_url_text_black, frame: frame) #黑名单中已添加的过滤规则列表
						div(:url_text_w, id: @@ts_tag_url_text_white, frame: frame) #白名单中已添加的过滤规则列表
						button(:url_save, id: @@ts_tag_security_save, frame: frame) #保存
						div(:url_items_max, class_name: @@ts_tag_aui_content, frame: frame) #条目超出限制提示
						div(:url_err_msg, class_name: @@ts_tag_aui_content, frame: frame) #url异常提示

						##MAC过滤
						link(:mac_filter, id: @@ts_tag_macfilter, frame: frame)
						span(:mac_add_item, id: @@ts_tag_additem, frame: frame) #添加新条目
						span(:mac_all_valid, id: @@ts_tag_alladd, frame: frame) #使所有条目生效
						span(:mac_all_invalid, id: @@ts_tag_allcancel, frame: frame) #使所有条目失效
						span(:mac_all_del, id: @@ts_tag_alldel, frame: frame) #删除所有条目
						text_field(:mac_addr, id: @@ts_tag_fwmac_mac, frame: frame) #MAC地址
						text_field(:mac_addr1, id: @@ts_tag_fwmac_mac1, frame: frame) #编辑后的MAC地址
						text_field(:mac_desc, id: @@ts_tag_fwmac_desc, frame: frame) #描述
						text_field(:mac_desc1, id: @@ts_tag_fwmac_desc1, frame: frame) #编辑后的描述
						select_list(:mac_status, id: @@ts_tag_fw_select, frame: frame) #状态
						select_list(:mac_status1, id: @@ts_tag_fw_select1, frame: frame) #编辑后的状态
						button(:mac_save, id: @@ts_tag_save_filter, frame: frame) #保存
						button(:mac_save1, id: @@ts_tag_save_filter1, frame: frame) #编辑后的保存
						table(:mac_filter_table, id: @@ts_tag_mac_table, frame: frame)
						paragraph(:mac_filter_err_msg, id: @@ts_tag_err_msg, frame: frame) #mac过滤错误提示
						div(:mac_items_max, class_name: @@ts_tag_aui_content, frame: frame) #条目超出限制提示
						link(:mac_hint_close, class_name: @@ts_ip_hint_close, frame: frame) #关闭提示信息
				end
		end

		class OptionsPage < MainPage
				include Options_Page

				#打开防火墙设置
				def firewall_click(time=3)
						self.firewall
						sleep time
				end

				#打开ip过滤页面
				def ipfilter_click(time=5)
						self.ip_filter
						sleep time
				end

				#打开url过滤页面
				def urlfilter_click(time=5)
						self.url_filter
						sleep time
				end

				#打开mac过滤页面
				def macfilter_click(time=5)
						self.mac_filter
						sleep time
				end

				#mac过滤输入
				def mac_filter_input(addr, desc, status="生效")
						self.mac_addr_element.click
						self.mac_addr = addr
						#第一次输入失败则反复输入，最多3次
						mac_empty     = true
						if self.mac_addr.nil?||self.mac_addr.empty?
								puts "input mac addr #{addr} again!"
								3.times.each do
										self.mac_addr_element.click
										self.mac_addr = addr
										mac_empty     = self.mac_addr.nil?||self.mac_addr.empty?
										break unless mac_empty
								end
								puts "input mac address #{addr} failed!" if mac_empty
						end

						self.mac_desc_element.click
						self.mac_desc = desc
						#第一次输入失败则反复输入，最多3次
						desc_empty    = true
						if self.mac_desc.nil?||self.mac_desc.empty?
								puts "input mac desc #{desc} again!"
								3.times.each do
										self.mac_desc_element.click
										self.mac_desc = desc
										desc_empty    = self.mac_desc.nil?||self.mac_desc.empty?
										break unless desc_empty
								end
								puts "input mac desc #{desc} failed!" if desc_empty
						end

						sleep 1
						mac_status_element.select(/#{status}/)
				end

				#mac过滤保存
				def mac_filter_save(time=6)
						self.mac_save
						sleep time
				end

				#mac过滤，关闭总开关并删除所有过滤规则步骤
				def macfilter_close_sw_del_all(url)
						open_options_page(url)
						security_settings #安全设置
						sleep 2
						firewall_click
						open_switch("on", "off", "on", "off")
						macfilter_click
						mac_all_del_element.click #删除所有条目
						sleep 5
						firewall_click #防火墙设置
						close_switch #关闭总开关
				end

				#保存防火墙开关设置
				def save_firewarll(time = 5)
						self.firewall_save
						sleep time
				end

				#url过滤输入
				def url_filter_input(url)
						sleep 1
						self.url_url_element.click
						self.url_url = url
						url_add
				end

				#url过滤类型选择
				def select_urlfilter_type(type)
						sleep 1
						self.url_filter_type = type
				end

				#url过滤保存
				def url_filter_save(time=15)
						url_save
						sleep time
				end

				#url过滤删除单个规则
				#type为类型(black, white)， url为要删除的url
				def urlfilter_del(type, url)
						if type == "black"
								select_urlfilter_type(@@ts_tag_url_type_black)
								all_size = url_text_b_element.element.lis.size
								return if all_size == 0
								for i in 0..all_size-1
										if url_text_b_element.element.lis[i].span.text == url
												url_text_b_element.element.lis[i].span.click
												url_text_b_element.element.lis[i].span.click #重复点击一次，防止出错
												sleep 1
												url_text_b_element.element.lis[i].link.click
												break
										end
								end
						elsif type == "white"
								select_urlfilter_type(@@ts_tag_url_type_white)
								all_size = url_text_w_element.element.lis.size
								return if all_size == 0
								for i in 0..all_size-1
										if url_text_w_element.element.lis[i].span.text == url
												url_text_w_element.element.lis[i].span.click
												url_text_w_element.element.lis[i].span.click #重复点击一次，防止出错
												sleep 1
												url_text_w_element.element.lis[i].link.click
												break
										end
								end
						end
						url_filter_save
				end

				#url过滤删除所有规则,包括黑白名单
				def urlfilter_del_all
						select_urlfilter_type(@@ts_tag_url_type_black)
						all_size = url_text_b_element.element.lis.size
						unless all_size == 0
								puts "Delete rule for blacklist"
								for i in 0..all_size-1
										item = url_text_b_element.element.lis[0].span.text
										puts "Url rule delete: #{item} "
										url_text_b_element.element.lis[0].span.click
										url_text_b_element.element.lis[0].span.click #重复点击一次，防止出错
										sleep 1
										url_text_b_element.element.lis[0].link.click
										sleep 1
								end
								url_filter_save
						end

						url_filter #必须再进入url过滤界面，否则无法保存，具体原因未知
						select_urlfilter_type(@@ts_tag_url_type_white)
						all_size = url_text_w_element.element.lis.size
						unless all_size == 0
								puts "Delete rule for whitelist"
								for i in 0..all_size-1
										item = url_text_w_element.element.lis[0].span.text
										puts "Url rule delete: #{item} "
										url_text_w_element.element.lis[0].span.click
										url_text_w_element.element.lis[0].span.click #重复点击一次，防止出错
										sleep 1
										url_text_w_element.element.lis[0].link.click
										sleep 1
								end
								url_filter_save
						end
				end

				#url过滤关闭总开关并删除所有规则步骤
				def urlfilter_close_sw_del_all_step(url)
						open_options_page(url)
						security_settings #安全设置
						sleep 2
						firewall_click
						open_switch("on", "off", "off", "on")
						urlfilter_click
						urlfilter_del_all #删除所有规则
						firewall_click
						close_switch #关闭总开关
				end

				#ip过滤新增条目源ip输入
				def ip_filter_src_ip_input(sip1, sip2=sip1)
						sleep 1
						self.src_ip_start_element.click
						self.src_ip_start = sip1
						self.src_ip_end_element.click
						self.src_ip_end = sip2
				end

				#ip过滤新增条目源端口输入
				def ip_filter_src_port_input(sp1, sp2=sp1)
						sleep 1
						self.src_port_start_element.click
						self.src_port_start = sp1
						self.src_port_end_element.click
						self.src_port_end = sp2
				end

				#ip过滤新增条目目的ip输入
				def ip_filter_dst_ip_input(dip1, dip2=dip1)
						sleep 1
						self.dst_ip_start_element.click
						self.dst_ip_start = dip1
						self.dst_ip_end_element.click
						self.dst_ip_end = dip2
				end

				#ip过滤新增条目目的端口输入
				def ip_filter_dst_port_input(dp1, dp2=dp1)
						sleep 1
						self.dst_port_start_element.click
						self.dst_port_start = dp1
						self.dst_port_end_element.click
						self.dst_port_end = dp2
				end

				#ip过滤新增条目目的端口1输入
				def ip_filter_dst_port1_input(dp1, dp2=dp1)
						sleep 1
						self.dst_port_start1_element.click
						self.dst_port_start1 = dp1
						self.dst_port_end1_element.click
						self.dst_port_end1 = dp2
				end

				#ip过滤保存配置
				def ip_filter_save(time=15)
						ip_save
						sleep time
				end

				#关闭总开关
				def close_switch
						firewall_switch if firewall_switch_element.class_name == "on"
						ip_filter_switch if ip_filter_switch_element.class_name == "on"
						mac_filter_switch if mac_filter_switch_element.class_name == "on"
						url_filter_switch if url_filter_switch_element.class_name == "on"
						save_firewarll
				end

				#打开总开关
				#打开为"on", 关闭为"off"
				def open_switch(fw_sw, ip_sw, mac_sw, url_sw)
						sleep 2
						flag = false
						unless firewall_switch_element.class_name == fw_sw
								firewall_switch
								flag = true
						end
						unless ip_filter_switch_element.class_name == ip_sw
								ip_filter_switch
								flag = true
						end
						unless mac_filter_switch_element.class_name == mac_sw
								mac_filter_switch
								flag = true
						end
						unless url_filter_switch_element.class_name == url_sw
								url_filter_switch
								flag = true
						end
						if flag
								sleep 2
								save_firewarll
						end
				end

				#ip过滤关闭总开关并删除所有条目步骤
				def ipfilter_close_sw_del_all_step(url)
						open_options_page(url)
						security_settings #安全设置
						sleep 3
						firewall_click
						open_switch("on", "on", "off", "off")
						ipfilter_click #ip过滤
						ip_all_del_element.click #删除所有条目
						sleep 10 # 删除所有时等待时间略长
						firewall_click #防火墙设置
						close_switch #关闭总开关
				end

				#打开高级设置-进入安全设置
				def open_security_page_step(url)
						open_options_page(url)
						security_settings #安全设置
						sleep 2
				end

				#点击添加MAC规则
				def mac_filter_add
						self.mac_add_item_element.click
				end

		end
end















