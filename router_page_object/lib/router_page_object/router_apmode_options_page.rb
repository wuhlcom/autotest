#encoding:utf-8
#
# AP模式高级设置
# author:wuhlcom
# date:2016-03-22
# modify:
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject

		module APOptions_Page
				include PageObject
				in_iframe(:src => @@ts_tag_apoption_src) do |frame|
						link(:apply_settings, id: @@ts_tag_application, frame: frame) ###应用设置
						link(:network, id: @@ts_tag_op_network, frame: frame) ###网络设置
						link(:security_settings, id: @@ts_tag_security, frame: frame) ###安全设置
						link(:traffic_manage, id: @@ts_tag_bandwidth, frame: frame) ###流量管理
						link(:sysset, id: @@ts_tag_op_system, frame: frame) ###系统设置

						link(:recover, id: @@ts_tag_recover, frame: frame) ##配置恢复
						button(:reset, id: @@ts_tag_reset_factory, frame: frame) #恢复出厂
						button(:reset_confirm, class_name: @@ts_tag_reboot_confirm, frame: frame) #确认恢复出厂
						button(:export, name: @@ts_tag_export_name, frame: frame) #导出设置
						file_field(:import_file, id: @@ts_tag_filename_new, frame: frame) #导入输入
						button(:import_btn, id: @@ts_tag_inport_btn, frame: frame) #导入按钮
						link(:update, id: @@ts_update, frame: frame) ##固件升级
						file_field(:update_file, id: @@ts_tag_filename_new, frame: frame) #升级输入
						button(:update_btn, id: @@ts_tag_update_btn, frame: frame) #升级按钮
						button(:update_confirm, class_name: @@ts_tag_reboot_confirm, frame: frame) #确认升级
						link(:file_share, id: @@ts_tag_fileshare, frame: frame) ##文件共享
						button(:file_share_btn, type: @@ts_tag_fileshare_btn_type, frame: frame) #文件共享按钮
				end
		end

		class APOptionsPage < MainPage
				include APOptions_Page

				#打开高级设置界面
				def open_options_page(url)
						# self.navigate_to url
						browser.refresh
						sleep 2
						5.times do
								if advance? && !(sys_version.slice(/系统版本:(.+)/, 1).nil?)
										self.advance_link_obj.click #点击高级设置
										sleep 6
										break if sysset?
								end
								self.clear_cookies
								self.refresh
								sleep 2
								login_with(@@ts_default_usr, @@ts_default_pw, url)
						end
				end

				#点击 网络设置 前判断网络设置是否已经被选中
				def sysset_click
						unless sysset_element.class_name=="selected"
								sysset
								sleep 2
						end
				end

		end
end

