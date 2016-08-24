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
						link(:sysset, id: @@ts_tag_op_system, frame: frame) ###系统设置
						##配置恢复
						link(:recover, id: @@ts_tag_recover, frame: frame)
						button(:reset, id: @@ts_tag_reset_factory, frame: frame) #恢复出厂
						button(:reset_confirm, class_name: @@ts_tag_reboot_confirm, frame: frame) #确认恢复出厂
						button(:export, name: @@ts_tag_export_name, frame: frame) #导出设置
						file_field(:import_file, id: @@ts_tag_filename_new, frame: frame) #导入输入
						button(:import_btn, id: @@ts_tag_inport_btn, frame: frame) #导入按钮
						div(:recover_err, class_name: @@ts_tag_aui_content, frame: frame) #錯誤提示
						link(:recover_err_close, class_name: @@ts_ip_hint_close, frame: frame) #关闭错误提示
						##外网访问web
						link(:web_access, id: @@ts_tag_op_remote, frame: frame)
						span(:web_acc, class_name: @@ts_tag_op_web_accbtn, frame: frame)
						# button(:web_access_btn, id: @@ts_tag_btn_off, frame: frame) #外网访问开关
						text_field(:web_access_port, id: @@ts_remote_port_id, frame: frame) #外网访问端口
						button(:web_access_save, id: @@ts_remote_save_btn, frame: frame) #保存
						##固件升级
						link(:update, id: @@ts_update, frame: frame)
						file_field(:update_file, id: @@ts_tag_filename_new, frame: frame) #升级输入
						button(:update_btn, id: @@ts_tag_update_btn, frame: frame) #升级按钮
						button(:update_confirm, class_name: @@ts_tag_reboot_confirm, frame: frame) #确认升级
						div(:update_err_msg, class_name: @@ts_tag_aui_content, frame: frame) #异常提示
						##文件共享
						link(:file_share, id: @@ts_tag_fileshare, frame: frame)
						button(:file_share_btn, type: @@ts_tag_fileshare_btn_type, frame: frame) #文件共享按钮
						##设备域名
						link(:domain, id: @@ts_tag_domain, frame: frame)
						text_field(:domain_name, id: @@ts_tag_domain_name, frame: frame) #域名输入
						button(:save_domain_btn, id: @@ts_tag_sbm, frame: frame) #保存域名
						paragraph(:domain_error, id: @@ts_tag_domain_err, frame: frame) #保存域名
						##定时重启
						link(:restart, id: @@ts_tag_plan_task, frame: frame)
						span(:router_time, id: @@ts_tag_router_time, frame: frame) #路由器时间
						button(:restart_btn, id: @@ts_btn_id, frame: frame) #开关
						select_list(:restart_strategy, id: @@ts_tag_restart_strategy, frame: frame) #策略
						text_field(:date_first, id: @@ts_select_time_id, frame: frame) #时间
						link(:today, id: @@ts_today_id, frame: frame) #今天
						link(:ensure_btn, id: @@ts_time_ok, frame: frame) #确定
						link(:clear_time, id: @@ts_tag_clear_time, frame: frame) #清空
						list_item(:restart_set_time, class_name: @@ts_time_classname, frame: frame) #设置时间
						div(:restart_min, id: @@ts_time_minute, frame: frame) #设置分钟
						paragraph(:restart_save, id: @@ts_rebot_btn, frame: frame) #保存
				end
		end

		class OptionsPage < MainPage
				include Options_Page

				#高级设置-系统设置-定时重启
				def open_restart_page(url)
						open_options_page(url)
						open_sysset_page
						restart
						sleep 2
				end

				#打开系统设置页面
				def open_sysset_page
						3.times do
								sysset
								sleep 2
								break if update?
						end
				end

				#清空时间并关闭状态开关
				def clear_all_time(url, time=2)
						open_restart_page(url)
						open_restart_btn
						sleep 1
						date_first_element.click #打开时间
						sleep 1
						clear_time
						sleep 1
						close_restart_btn
						sleep 1
						restart_save_element.click
						sleep time
				end

				#设置当前时间一分钟后定时重启的步骤
				def restart_step(url, strategy="一次", time=2)
						open_restart_page(url)
						open_restart_btn
						sleep 1
						cur_time     = router_time #2016-04-15 17:20:17
						cur_time_min = cur_time.slice(/(\d+)\-(\d+)\-(\d+)\s*(\d+):(\d+):(\d+)/i, 5) #得到当前日期的分钟
						set_time     = (cur_time_min.to_i + 1).to_s #设置的重启时间为当前时间的下一分钟
						if set_time == "60" #如果当前分钟为59，直接等待一分钟后再重新设置，这样是防止当前分钟为59或者小时分钟为23:59的情况
								sleep 60
								set_time = "1"
						end
						restart_strategy = strategy #选择策略
						date_first_element.click #打开时间
						today #选择今天
						date_first_element.click #再次打开时间
						restart_set_time_element.element.parent.lis[2].text_field.click #设置时间，直接设置分钟时间
						restart_min_element.element.span(text: set_time).click
						ensure_btn #确定
						restart_save_element.click
						sleep time
				end


				#打开定时重启开关
				def open_restart_btn
						restart_btn if restart_btn_element.class_name == "off"
				end

				#关闭定时重启开关
				def close_restart_btn
						restart_btn if restart_btn_element.class_name == "on"
				end

				#系统设置-配置恢复页面
				def select_recover
						open_sysset_page
						recover
						sleep 2
				end

				#系统设置-固件升级页面
				def select_update
						open_sysset_page
						update
						sleep 2
				end

				#系统设置-文件共享页面
				def select_fileshare
						open_sysset_page
						file_share
						sleep 2
				end

				#打开高级设置-系统设置-外网访问WEB
				def select_web_access(url)
						open_options_page(url)
						open_sysset_page
						web_access
						sleep 2
				end

				#打开恢复出厂页面-点击恢复出厂-确认恢复出厂设置
				def recover_click
						select_recover
						recover_btn
				end

				#打开高级设置-打开恢复出厂页面-点击恢复出厂-确认恢复出厂设置
				def recover_factory(url)
						open_options_page(url)
						recover_click
				end

				#点击恢复出厂按钮-确认恢复出厂
				def recover_btn(time=90)
						reset
						sleep 2
						self.reset_confirm
						puts "sleep #{time} seconds for restoring to factory"
						sleep time #wait for recover
				end

				#外网访问端口输入
				def web_access_port_input(port)
						self.web_access_port_element.click
						self.web_access_port = port
				end

				#导入配置文件输入
				def set_import_file(file)
						self.import_file = file
				end

				#浏览器alter弹窗，点击确定按钮
				def alter_btn(browserobj, src=@@ts_tag_advance_src)
						require 'selenium-webdriver'
						frame   = browserobj.iframe(src: src)
						key_obj = frame.driver.switch_to.alert
						key_obj.accept
				end

				#导入配置文件步骤
				def import_file_step(url, file, time=110)
						open_options_page(url)
						select_recover #进入配置恢复
						set_import_file(file)
						sleep 1
						import_btn
						puts "Sleep #{time} seconds for net reset..."
						sleep time
				end

				#导出配置文件步骤
				def export_file_step(browserobj, url, time=10)
						open_options_page(url)
						select_recover #进入配置恢复
						export_element.click
						sleep 1
						alter_btn(browserobj)
						puts "Waiting for export configuration files..."
						sleep time
				end

				#升级输入
				def set_update_file(file)
						self.update_file = file
				end

				#固件升级步骤
				def update_step(url, file, time=200)
						open_options_page(url)
						select_update #进入固件升级页面
						set_update_file(file)
						sleep 1
						update_btn
						sleep 3
						#高版本升低版本会出现提示
						update_confirm if update_confirm_element.exists?
						puts "sleep #{time} seconds for system reboot...."
						sleep time
				end

				#打开文件共享页面
				def open_fileshare_page(url)
						open_options_page(url)
						select_fileshare #进入文件共享页面
						sleep 3
						file_share_btn if file_share_btn_element.exists? #打开共享开关
						sleep 2
				end

				#保存域名设置
				def save_domain(time = 10)
						self.save_domain_btn
						sleep time
				end

				#选择域名设置
				def select_domain(url)
						open_options_page(url)
						open_sysset_page
						domain
						sleep 2
				end

				#设置域名并保存
				def set_domain(dmname, url)
						select_domain(url)
						self.domain_name_element.click
						self.domain_name=dmname
						save_domain
				end

				#打开高级设置-系统设置-外网访问WEB-定位外网访问开关
				def get_web_accbtn(url)
						select_web_access(url)
						self.web_acc_element.button_element
				end

				#打开高级设置-系统设置-外网访问WEB-打开外网访问
				def open_web_access_btn(url)
						btn = get_web_accbtn(url)
						unless btn.class_name==@@ts_tag_btn_on
								btn.click
						end
				end

				#打开高级设置-系统设置-外网访问WEB-关闭外网访问
				def close_web_access_btn(url)
						btn = get_web_accbtn(url)
						if btn.class_name==@@ts_tag_btn_on
								btn.click
						end
				end

				#保存外网访问控制设置
				def save_web_access(time = 5)
						self.web_access_save
						sleep time
				end

				#打开高级设置-系统设置-外网访问WEB-打开外网访问并保存
				def open_web_access(url)
						open_web_access_btn(url)
						save_web_access
				end

				#打开高级设置-系统设置-外网访问WEB-关闭外网访问并保存
				def close_web_access(url)
						close_web_access_btn(url)
						save_web_access
				end

		end
end















