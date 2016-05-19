#encoding:utf-8
#
# 路由器高级设置
# author:liluping
# date:2016-03-02
# modify:
#
libs = Dir.glob(File.expand_path(File.dirname(__FILE__))+"/router_options_page/*")
libs.each { |lib|
		next unless File.extname(lib)==".rb"
		require lib
}
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject

		module Options_Page
				include PageObject
				in_iframe(:src => @@ts_tag_advance_src) do |frame|
						link(:close_options, class_name: @@ts_tag_aui_close, text: @@ts_tag_aui_clsignal) #close options page
				end
		end

		class OptionsPage < MainPage
				include Options_Page

				#打开高级设置界面
				def open_options_page(url)
						# self.navigate_to url
						self.refresh
						sleep 2
						5.times do
								break if dev_list? && !(dev_list_element.parent.em_element.text.nil?)
								self.refresh
								sleep 2
						end
						self.advance_link_obj.click #点击高级设置
						sleep 5
				end

				#关闭系统状态界面
				def close_options_page
						if self.close_options?
								self.close_options
								sleep 1
						end
				end

				#打开应用设置界面
				def open_apply_page
						apply_settings_element.click #点击应用设置
						sleep 2
				end

				#点击 网络设置 前判断网络设置是否已经被选中
				def network_click
						unless network_element.class_name=="selected"
								network
								sleep 3
						end
				end

				#点击流量管理
				def select_traffic
						unless traffic_manage_element.class_name=="selected"
								self.traffic_manage
								sleep 3
						end
				end

				#打开安全设置页面
				def open_security_setting(url)
						open_options_page(url)
						security_settings
						sleep 3
				end

		end
end

