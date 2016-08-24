#encoding:utf-8
#
# 路由器高级设置
# author:wuhongliang
# date:2016-03-09
# modify:
#
# file_path1 = File.expand_path('../router_main_page', __FILE__)
# require file_path1
module RouterPageObject
		module Options_Page
				include PageObject
				in_iframe(:src => @@ts_tag_advance_src) do |frame|
						link(:traffic_manage, id: @@ts_tag_bandwidth, frame: frame) ###流量管理
						link(:traffic_ctl, id: @@ts_tag_traffic, frame: frame) #流量控制
						checkbox(:traffic_sw, id: @@ts_tag_bandsw, frame: frame)
						text_field(:total_bw, id: @@ts_tag_wideband, frame: frame)
						button(:add_item, id: @@ts_tag_addvir, frame: frame)
						table(:bw_table, id: @@ts_tag_wifitable, frame: frame)
						(0..7).each do |i|
								item = "span(:ip_segment#{i},id:'ip_block_#{i}', frame: frame)
						text_field(:bw_ip_min#{i}, id: 'ip_range_min_#{i}', frame: frame)
						text_field(:bw_ip_max#{i}, id: 'ip_range_max_#{i}', frame: frame)
						select_list(:bw_type#{i}, id: 'wideband_mode_#{i}', frame: frame)
					  text_field(:bw_size#{i}, id: 'wideband_size_#{i}', frame: frame)
						select_list(:bw_status#{i}, id: 'status#{i}', frame: frame)
						cell(:bw_td#{i},text:'#{i+1}',frame: frame)"
								eval(item)
						end
						button(:save_item, id: @@ts_tag_sbm, frame: frame)
						button(:delete_item_all, id: @@ts_tag_delvir, frame: frame)
						span(:error_msg, id: @@ts_tag_wan_err, frame: frame)
				end
		end

		class OptionsPage < MainPage
				include Options_Page

				#高级设置->流量管理
				def open_traffic_manage(url)
						open_options_page(url)
						select_traffic
				end

				#高级设置->流量管理->流量控制
				def select_traffic_ctl(url)
						open_traffic_manage(url)
						unless traffic_ctl_element.parent.class_name=="active"
								self.traffic_ctl
								sleep 3
						end
				end

				#高级设置->流量管理->流量控制->勾选IP带宽控制
				def select_traffic_sw
						self.check_traffic_sw
				end

				#高级设置->流量管理->流量控制->去勾选流量控制
				def unselect_traffic_sw(time=5)
						self.uncheck_traffic_sw
						sleep time
				end

				#高级设置->流量管理->流量控制->输入带宽控制总带宽
				def set_total_bw(bw)
						self.total_bw_element.click
						self.total_bw=bw
				end

				#id从1开始
				#添加IP过滤规则
				def set_client_bw(id, min, max, type, size, status="生效")
						fail "ID must more than 1" if id.to_i<1
						id = id-1
						send "bw_type#{id}=", "#{type}"
						send "bw_status#{id}=", "#{status}"
						add_bw = "
						 self.bw_ip_min#{id}_element.click
						 self.bw_ip_min#{id}=#{min}
						 self.bw_ip_max#{id}_element.click
						 self.bw_ip_max#{id}=#{max}
						 self.bw_size#{id}_element.click"
						eval(add_bw)
						send "bw_size#{id}=", "#{size}"
				end

				#高级设置->流量管理->流量控制->保存
				def save_traffic(time=5)
						self.save_item
						sleep time
				end

		end

end















