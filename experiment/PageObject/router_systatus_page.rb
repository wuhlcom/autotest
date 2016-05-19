#encoding:utf-8
#router system info page tags
#author:wuhongliang

require './router_main_page'
module RouterPageObject
		module Systatus_Page
				include PageObject
				in_iframe(src: @@ts_sys_status_src) do |frame|
						b(:product_type, id: @@ts_tag_sysprotype, frame: frame)
						b(:run_time, id: @@ts_tag_sysruntime, frame: frame)
						b(:product_ver, id: @@ts_tag_sysprover, frame: frame)
						b(:terminal_num, id: @@ts_tag_systerminal, frame: frame)
						b(:software_ver, id: @@ts_tag_syssoftver, frame: frame)
						b(:hardware_ver, id: @@ts_tag_syshardver, frame: frame)
						paragraph(:wan_type, id: @@ts_tag_syswan, frame: frame)
						b(:wan_mac, id: @@ts_tag_syswanmac, frame: frame)
						b(:wan_ip, id: @@ts_tag_syswanip, frame: frame)
						b(:wan_mask, id: @@ts_tag_syswanmask, frame: frame)
						b(:wan_gw, id: @@ts_tag_syswangw, frame: frame)
						b(:wan_dns, id: @@ts_tag_syswandns, frame: frame)
						b(:lan_ip, id: @@ts_tag_syslanip, frame: frame)
						b(:lan_mask, id: @@ts_tag_syslanmask, frame: frame)
						b(:lan_mac, id: @@ts_tag_syslanmac, frame: frame)
						h3(:wifi_status, id: @@ts_tag_syswifistatus, frame: frame)
						paragraph(:wifi_switch, id: @@ts_tag_syswifisw, frame: frame)
						b(:wifi_ssid, id: @@ts_tag_sys_ssid, frame: frame)
						b(:wifi_channel, id: @@ts_tag_syschanel, frame: frame)
						b(:wifi_encry, id: @@ts_tag_sysencry, frame: frame)
				end

		end

		class SystatusPage<MainPage
				include Systatus_Page

				#"产品类型"对象
				def product_parent_obj
						self.product_type_element.parent
				end

				#获取产品类型
				def get_protype
						self.product_parent_obj
						str = self.product_parent_obj.text
						/\p{Han}+\s*(?<type>.*)/um=~str
						type
				end

				#WAN"MAC地址"对象
				def wan_mac_obj
						wan_mac_element.parent
				end

				#获取WAN MAC
				def get_wan_mac
						str = self.wan_mac_obj.text
						/MAC\p{Han}+\s*(?<mac>.*)/ium=~str
						mac
				end

				#获取WAN接入类型
				def get_wan_type
						str = self.wan_type
						/\p{Han}+\s*(?<type>.*)/ium=~str
						type
				end

				#WAN IP对象
				def wan_ip_obj
						wan_ip_element.parent
				end

				#获取WAN IP
				def get_wan_ip
						str = self.wan_ip_obj.text
						/IP\p{Han}+\s*(?<wanip>.*)/ium=~str
						wanip
				end

				#WAN MASK 对象
				def wan_mask_obj
						wan_mask_element.parent
				end

				#获取WAN MASK
				def get_wan_mask
						str = self.wan_mask_obj.text
						/IP\p{Han}+\s*(?<mask>.*)/ium=~str
						mask
				end

				#WAN 网关对象
				def wan_gw_obj
						wan_gw_element.parent
				end

				#获取网关地址
				def get_wan_gw
						str = self.wan_mask_obj.text
						/\p{Han}+\s*(?<gw>.*)/ium=~str
						gw
				end

				#dns 对象
				def wan_dns_obj
						wan_dns_element.parent
				end

				#DNS地址
				def get_wan_dns
						str = self.wan_dns_obj.text
						/DNS\p{Han}+\s*(?<dns>.*)/ium=~str
						dns
				end

				#lan mac 对象
				def lan_mac_obj
						lan_mask_element.parent
				end

				#获取lan mac
				def get_lan_mac
						str = self.lan_mac_obj.text
						/MAC\p{Han}+\s*(?<mac>.*)/ium=~str
						mac
				end

				#lan ip 对象
				def lan_ip_obj
						lan_ip_element.parent
				end

				#获取lan ip
				def get_lan_ip
						str = self.lan_ip_obj.text
						/IP\p{Han}+\s*(?<ip>.*)/ium=~str
						ip
				end

				#lan mac obj
				def lan_mask_obj
						lan_mask_element.parent
				end

				#get lan mask
				def get_lan_mask
						str = self.lan_mask_obj.text
						/\p{Han}+\s*(?<mask>.*)/ium=~str
						mask
				end

				#"更多"超链接对象
				def more_obj
						self.wifi_status_element.link_element
				end

				#wifi开关状态
				def get_wifi_switch
						str = self.wifi_switch
						/WIFI.+\s+(?<status>.*)/ium=~str
						status
				end

				def wifi_ssid_obj
						wifi_ssid_element.parent
				end

				#get无线SSID
				def get_wifi_ssid
						str = self.wifi_ssid_obj.text
						/SSID\s*(?<ssid>.*)/ium=~str
						ssid
				end

				def wifi_channel_obj
						wifi_channel_element.parent
				end

				#获取当前信道
				def get_wifi_channel
						str = self.wifi_channel_obj.text
						/\p{Han}+\s*(?<channel>.*)/ium=~str
						channel
				end

				def wifi_encry_obj
						wifi_encry_element.parent
				end

				#当前加密方式
				def get_wifi_encry
						str = self.wifi_encry_obj.text
						/\p{Han}+\s*(?<encrytion>.*)/ium=~str
						encrytion
				end
		end
end


if __FILE__==$0
		require 'pp'
		url      = "192.168.100.1"
		usrname  = "admin"
		passwd   = "admin"
		@browser = Watir::Browser.new :firefox
		sys_page = RouterPageObject::SystatusPage.new(@browser)
		sys_page.navigate_to url
		sys_page.login_with(usrname, passwd)
		sys_page.systatus_link_obj.click
		sleep 3 #必须等待
		# sys_page.get_wifi_encry
		# sys_page.get_wifi_channel
		# sys_page.get_wifi_switch
		p sys_page.get_wan_type
		# p sys_page.more_obj
		# p sys_page.more_obj.click
		# p type.encode("GBK")
		# p sys_page.product_parent_obj
		# p sys_page.product_parent_obj.text
		# p sys_page.product_parent_obj.text.encode("GBK")
end