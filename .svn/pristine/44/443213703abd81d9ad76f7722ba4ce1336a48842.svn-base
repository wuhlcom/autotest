#encoding:utf-8
#router main page tags
#get sub page object,such as wanset,lanset,advance,wifi,mode pages
#date:2016-02-24
#author:wuhongliang
file_path1 =File.expand_path('../router_login_page', __FILE__)
require file_path1
module RouterPageObject
		##定位主面的
		module Main_Page
				include PageObject
				span(:wan, id: @@ts_tag_netset) #WAN设置
				span(:mode, id: @@ts_tag_mode) #模式设置
				span(:lan, id: @@ts_tag_lan) #LAN设置
				span(:wifi, id: @@ts_tag_wifi) #f无线设置
				link(:netdect_page, id: @@ts_tag_diagnose) #系统诊断
				span(:reboot, id: @@ts_tag_reboot) #重启
				#reboot confirm button
				button(:reboot_confirm, class_name: @@ts_tag_reboot_confirm)
				link(:advance, id: @@ts_tag_options) #高级设置
				link(:systatus, id: @@ts_sys_status) #系统状态
				link(:guide, id: @@ts_tag_guide) #设置向导
				image(:rtmode_wz, src: @@ts_tag_step0) #路由模式向导
				image(:wanset_wz, src: @@ts_tag_step1) #WAN设置向导
				image(:lanset_wz, src: @@ts_tag_step2) #LAN设置向导
				image(:wifiset_wz, src: @@ts_tag_step3) #WIFI设置向导
				image(:wz_finish, src: @@ts_tag_step4) #设置向导完成
				map(:rtmode_wz_map, id: @@ts_tag_map0) #路由模式向导-跳过
				map(:wanset_wz_map, id: @@ts_tag_map1) #WAN设置向导-跳过
				map(:lanset_wz_map, id: @@ts_tag_map2) #LAN设置向导-跳过
				map(:wifiset_wz_map, id: @@ts_tag_map3) #WIFI设置向导-跳过
				map(:wz_finish_map, id: @@ts_tag_map4) #开始使用
				link(:logout, id: @@ts_tag_logout) #退出
				link(:acount_config, id: @@ts_tag_modify_pw)#账户管理
				span(:macinfo, id: @@ts_tag_systemver)
				span(:dev_list, class_name: @@ts_tag_devlist) #已连接设备列表
				span(:sys_version, id: @@ts_tag_systemver) #系统版本
		end

		class MainPage<LoginPage
				include Main_Page

				def wan_span_obj #wan设置对象
						wan_element
				end

				def mode_span_obj #模式设置对象
						mode_element
				end

				def lan_span_obj #lan设置对象
						lan_element
				end

				def wifi_span_obj #wifi
						wifi_element
				end

				def advance_link_obj #高级
						advance_element
				end

				def systatus_link_obj #系统状态
						systatus_element
				end

				def reboot_span_obj #重启按钮
						reboot_element
				end

				def reboot(time=120)
						self.refresh
						sleep 2
						self.reboot_element.click
						sleep 2
						self.reboot_confirm
						puts "sleeping #{time} for router rebooting..."
						sleep time #add sleep time wuhongliang 2016-03-08
				end

				#获取MAC地址
				def get_mac
						info = macinfo_element.parent.text
						/MAC\s*.*(?<mac_addr>\w+:\w+:\w+:\w+:\w+:\w+)/im=~info
						mac_addr
				end

				#获取MAC地址后6位
				def get_mac_last
						mac_arr = get_mac.split(":")
						mac_last="#{mac_arr[3]}#{mac_arr[4]}#{mac_arr[5]}"
				end

		end
end
