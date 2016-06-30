#encoding:utf-8
#router lan set page tags
#author:wuhongliang
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject
		module Lan_Page
				include PageObject
				in_iframe(src: @@ts_tag_lan_src) do |frame|
						text_field(:lan_ip, id: @@ts_tag_lanip, frame: frame) #lan ip
						text_field(:lan_mask, id: @@ts_tag_lanmask, frame: frame) #lan mask
						span(:lan_startip_pre, id: @@ts_tag_ipstart, frame: frame)
						span(:lan_endip_pre, id: @@ts_tag_ipend, frame: frame)
						text_field(:lan_startip, id: @@ts_tag_lanstart, frame: frame) #satrip
						text_field(:lan_endip, id: @@ts_tag_lanend, frame: frame) #end ip
						text_field(:dhcp_lease, id: @@ts_tag_dhcp_lease, frame: frame) #dhcp lease time
						label(:lan_error, id: @@ts_tag_lanerr, frame: frame)
						button(:save_lanset, id: @@ts_tag_sbm, frame: frame) #save button
						button(:dhcp_btn, type: @@ts_tag_dhcp_btn, frame: frame) #dhcp button
						div(:auti_titlebar, class_name: @@ts_tag_aui_titbar)
						link(:close_lan, class_name: @@ts_tag_aui_close, text: @@ts_tag_aui_clsignal) #close lanset
				end
		end

		class LanPage < MainPage
				include Lan_Page
				#打开lan设置页面
				def open_lan_page(url)
						# self.navigate_to url
						self.refresh
						sleep 2
						5.times do
								if advance? && !(sys_version.slice(/系统版本:(.+)/, 1).nil?)
										self.lan_span_obj.click
										sleep 5
										break if lan_ip?
								end
								self.clear_cookies
								self.refresh
								sleep 2
								login_with(@@ts_default_usr, @@ts_default_pw, url)
						end
				end

				#关闭lan设置界面
				def close_lan_page
						if self.close_lan?
								self.close_lan
								sleep 1
						end
				end

				def lan_ip_set(ip)
						self.lan_ip_element.click
						self.lan_ip=ip
						#当第一次输入IP失败，再反复输入，最多3次
						ip_empty   =true
						if self.lan_ip.nil? || self.lan_ip.empty? #ip如果输入失败，这里值为true
								puts "input ip #{ip} again"
								3.times.each do
										self.lan_ip_element.click
										self.lan_ip=ip
										ip_empty   = self.lan_ip.nil? || self.lan_ip.empty? #ip如果输入失败，这里值为true
										break unless ip_empty
								end
								puts "input ip #{ip} failed'" if ip_empty
						end
				end

				#修改掩码
				def lan_mask_set(mask)
						self.lan_mask_element.click
						self.lan_mask=mask

						mask_empty =true
						if self.lan_mask.nil? || self.lan_mask.empty?
								puts "input mask #{mask} again"
								3.times.each do
										self.lan_mask_element.click
										self.lan_mask=mask
										mask_empty   = self.lan_mask.nil? || self.lan_mask.empty?
										break unless mask_empty
								end
								puts "input mask #{mask} failed'" if mask_empty
						end
				end

				#num,ip地址最后一位
				def lan_startip_set(ip)
						self.lan_startip_element.click
						self.lan_startip =ip
						ip_empty         =true
						if self.lan_startip.nil? || self.lan_startip.empty?
								puts "input startip #{ip} again"
								3.times.each do
										self.lan_startip_element.click
										self.lan_startip=ip
										ip_empty        = self.lan_startip.nil? || self.lan_startip.empty?
										break unless ip_empty
								end
								puts "input startip #{ip} failed'" if ip_empty
						end
				end

				#num,ip地址最后一位
				def lan_endip_set(ip)
						self.lan_endip_element.click
						self.lan_endip=ip
						ip_empty      =true
						if self.lan_endip.nil? || self.lan_endip.empty?
								puts "input endip #{ip} again"
								3.times.each do
										self.lan_endip_element.click
										self.lan_endip=ip
										ip_empty      = self.lan_endip.nil? || self.lan_endip.empty?
										break unless ip_empty
								end
								puts "input endip #{ip} failed'" if ip_empty
						end
				end

				#dhcp 租期
				def dhcp_lease_set(leasetime)
						self.dhcp_lease_element.click
						self.dhcp_lease=leasetime
						leasetime_emp  =true
						if self.dhcp_lease.nil? || self.dhcp_lease.empty?
								puts "input leasetime #{leasetime} again"
								3.times.each do
										self.dhcp_lease_element.click
										self.dhcp_lease=leasetime
										leasetime_emp  = self.dhcp_lease.nil? || self.dhcp_lease.empty?
										break unless leasetime_emp
								end
								puts "input leasetime #{leasetime} failed'" if leasetime_emp
						end
				end

				def btn_save_lanset(time=80)
						self.save_lanset
						puts "sleep #{time} senconds for lan set saving"
						sleep time
						unless lan?
								refresh
								sleep 1
								refresh
						end
				end

				#set lan ip then save
				def lan_ip_config(ip, url)
						open_lan_page(url)
						lan_ip_set(ip)
						btn_save_lanset
				end

				#set startip then save
				def lan_startip_config(num, url)
						open_lan_page(url)
						lan_startip_set(num)
						btn_save_lanset
				end

				#set end ip then save
				def lan_endip_config(num, url)
						open_lan_page(url)
						lan_endip_set(num)
						btn_save_lanset
				end

				#set dhcp lease time then save
				def dhcp_lease_config(leasetime, url)
						open_lan_page(url)
						dhcp_lease_set(leasetime)
						btn_save_lanset
				end

				#set startip and endip then save
				def dhcp_pool_config(startip, endip, url)
						open_lan_page(url)
						lan_startip_set(startip)
						lan_endip_set(endip)
						btn_save_lanset
				end

		end

end