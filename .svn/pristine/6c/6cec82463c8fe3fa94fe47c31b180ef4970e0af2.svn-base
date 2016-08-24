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
						link(:apply_settings, id: @@ts_tag_application, frame: frame) ###应用设置
						link(:vps, id: @@ts_tag_virtualsrv, frame: frame) ##虚拟服务器
						button(:vps_switch, id: @@ts_tag_virtualsrv_sw, frame: frame) #虚拟服务器开关
						button(:add_vps_setting, id: @@ts_tag_addvir, frame: frame) #新增条目
						button(:save_vps_setting, id: @@ts_tag_save_btn, frame: frame) #保存
						button(:delete_allvps, id: @@ts_tag_delvir, frame: frame) #删除所有条目
						vps_set = ""
						for n in 1..6 #ip地址、公共端口、私有端口、删除
								vps_set << "
								  td(:vps_td#{n},text:'#{n}',frame:frame)
                text_field(:vps_ip#{n}, name: @@ts_tag_virip#{n}, frame: frame)
                text_field(:vps_common_port#{n}, name: @@ts_tag_virpub_port#{n}, frame: frame)
                text_field(:vps_private_port#{n}, name: @@ts_tag_virpri_port#{n}, frame: frame)
                link(:delete_vps#{n}, xpath: @@ts_tag_delete_vps#{n}, frame: frame)"
						end
						eval(vps_set)
						select_list(:protocol_type, name: @@ts_tag_vir_protocol, frame: frame) #协议
						select_list(:vps_status, name: @@ts_tag_vir_status, frame: frame) #状态
						span(:vps_error_msg, id: @@ts_tag_err_msg, frame: frame) #错误提示1
						div(:vps_aui_content, class_name: @@ts_tag_aui_content, text: @@ts_tag_aui_content_text, frame: frame) #错误提示2
						link(:dmz, id: @@ts_tag_dmz, frame: frame) ##dmz设置
						button(:dmz_switch, id: @@ts_tag_dmzsw, frame: frame) #dmz开关
						text_field(:dmz_host_ip, name: @@ts_tag_dmzip, frame: frame) #dmz主机IP地址
						button(:save_dmz_setting, id: @@ts_tag_sbm, frame: frame) #保存
						span(:dmz_error_msg, id: @@ts_tag_err_msg, frame: frame) #错误提示
				end
		end

		class OptionsPage < MainPage
				include Options_Page

				#打开虚拟服务器界面
				def open_vps_page
						self.vps #点击虚拟服务器叶签
						sleep 2
				end

				#打开dmz设置界面
				def open_dmz_page
						self.dmz
						sleep 2 #点击dmz设置叶签
				end

				#高级设置-应用设置-DMZ
				def dmz_page(url)
						open_options_page(url)
						open_apply_page
						open_dmz_page
				end

				#虚拟服务器开关状态
				def vps_switch_status
						vps_switch_element.class_name
				end

				#虚拟服务器开关操作
				def click_vps_switch
						vps_switch
				end

				#新增虚拟服务器条目
				def add_vps
						add_vps_setting
				end

				#打开虚拟服务器
				def open_vps_btn
						if vps_switch_element.class_name=="off"
								self.vps_switch
						end
				end

				#关闭虚拟服务器
				def close_vps_btn
						if vps_switch_element.class_name=="on"
								self.vps_switch
						end
				end

				#虚拟服务器保存
				def save_vps(time=10)
						save_vps_setting
						sleep time
				end

				#删除所有虚拟服务器条目
				def delete_all_vps
						delete_allvps
				end

				#输入新增虚拟服务器条目配置
				#id是条目ID
				#ID       ip地址          公共端口    私有端口
				#1    192.168.100.100      10001        10001
				def vps_input(ip, common_port, private_port, id=1, protocol="ALL", status="生效")
						rs = "self.vps_ip#{id}_element.click
            self.vps_ip#{id}           = ip
            self.vps_common_port#{id}_element.click
            self.vps_common_port#{id}  = common_port
            self.vps_private_port#{id}_element.click
						 self.vps_private_port#{id} = private_port

           #当第一次输入IP失败，再反复输入，最多3次
						 ip_empty=true
			      if self.vps_ip#{id}.nil? || self.vps_ip#{id}.empty?
               puts 'input ip #{ip} again'
				        3.times.each do
                    self.vps_ip#{id}_element.click
						         self.vps_ip#{id}        = ip
											ip_empty = self.vps_ip#{id}.nil? || self.vps_ip#{id}.empty?
                   break unless ip_empty
								end
              puts 'input ip #{ip} failed' if ip_empty
						end

				    #当第一次输入外网端口失败，再反复输入，最多3次
						 comport_empty = true
            if self.vps_common_port#{id}.nil? || self.vps_common_port#{id}.empty?
               puts 'input common port #{common_port} again'
				        3.times.each do
                   self.vps_common_port#{id}_element.click
                   self.vps_common_port#{id}  = common_port
											comport_empty = self.vps_common_port#{id}.nil? || self.vps_common_port#{id}.empty?
                   break unless comport_empty
								end
							 puts 'input common_port #{common_port} failed' if comport_empty
						end

           #当第一次输入服务端口失败，再反复输入，最多3次
						 priport_empty = true
            if self.vps_private_port#{id}.nil? || self.vps_private_port#{id}.empty?
               puts 'input pri port #{private_port} again'
				        3.times.each do
                   self.vps_private_port#{id}_element.click
						        self.vps_private_port#{id} = private_port
											priport_empty = self.vps_private_port#{id}.nil? || self.vps_private_port#{id}.empty?
                   break unless priport_empty
								end
								puts 'input private_port #{private_port} failed' if comport_empty
						end"
						eval(rs)
						protocol_type_element.select(protocol)
						vps_status_element.select(status)
				end

				#删除新增的条目
				#vps_id为要删除的条目的id值
				def delete_vps(vps_id)
						eval("delete_vps#{vps_id}")
				end

				#虚拟服务器错误提示
				def vps_err_msg
						#如果错误提示不存在，则返回一个false
						err_msg_exists = vps_error_msg_element.exists?
						return false unless err_msg_exists
						vps_error_msg_element.text
				end

				#高级设置-应用设置-虚拟服务
				def open_vps(url)
						open_options_page(url)
						open_apply_page
						open_vps_page
				end

				#高级设置-应用设置-虚拟服务-打开虚拟服务器开关
				def open_vps_step(url)
						open_vps(url)
						open_vps_btn
				end

				#删除所有虚拟服务器条目并关闭虚拟服务器开关步骤
				def delete_allvps_close_switch_step(url, time=5)
						open_vps(url)
						delete_all_vps
						close_vps_btn
						save_vps(time)
				end

				#dmz设置开关状态
				def dmz_switch_status
						self.dmz_switch_element.class_name
				end

				#dmz设置开关操作
				def click_dmz_switch
						self.dmz_switch
				end

				#dmz打开
				def open_dmz_switch
						self.dmz_switch if dmz_switch_status == "off"
				end

				#dmz关闭
				def close_dmz_switch
						self.dmz_switch if dmz_switch_status == "on"
				end

				#dmz主机ip地址输入
				def dmz_input(ip)
						self.dmz_host_ip = ip
				end

				#dmz设置保存
				def save_dmz(time=5)
						save_dmz_setting
						sleep time
				end

				#设置dmz步骤
				def set_dmz(ip, url)
						dmz_page(url)
						open_dmz_switch
						dmz_input(ip)
						save_dmz
				end

				#dmz错误提示
				def dmz_err_msg
						#如果错误提示不存在，则返回一个false
						err_msg_exists = dmz_error_msg_element.exists?
						return false unless err_msg_exists
						dmz_error_msg_element.text
				end

				#打开高级设置-应用设置-虚拟服务器-新增条目-输入IP,端口,协议，是否生效-保存
				def add_vps_step(url, srv_ip, put_port, pri_port, id, protocol="ALL", status="生效")
						open_vps_step(url)
						add_vps
						vps_input(srv_ip, put_port, pri_port, id, protocol, status)
						save_vps
				end
		end
end















