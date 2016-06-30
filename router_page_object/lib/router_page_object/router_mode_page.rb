#encoding:utf-8
#router mode set page
#author:wuhongliang
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1
module RouterPageObject
		module Mode_Page
				include PageObject
				in_iframe(src: @@ts_tag_mode_iframe) do |frame|
						# adds four methods - one to select,
						# another to return if a radio button is selected,
						# another method to return a PageObject::Elements::RadioButton object representing the radio button element,
						# and another to check the radio button's existence.
						# Examples:
						# 		radio_button(:north, :id => "north")
						#     will generate 'select_north', 'north_selected?','north_element', and 'north?' methods
						radio_button(:apmode, id: @@ts_tag_apmode, frame: frame)
						radio_button(:routermode, id: @@ts_tag_routermode, frame: frame)
						button(:save_mode, id: @@ts_tag_sbm, frame: frame) #save button
						link(:close_mode, class_name: @@ts_tag_aui_close, text: @@ts_tag_aui_clsignal) #close modeset
				end
		end

		class ModePage<MainPage
				include Mode_Page
				#打开模式页面
				def open_mode_page(url)
						# self.navigate_to url
						self.refresh #最少要先刷新两次
						sleep 2
						5.times do
								if advance? && !(sys_version.slice(/系统版本:(.+)/, 1).nil?)
										self.mode_span_obj.click
										sleep 5
										break if apmode?
								end
								self.clear_cookies
								self.refresh
								sleep 2
								login_with(@@ts_default_usr, @@ts_default_pw, url)
						end
				end

				#关闭模式界面
				def close_mode_page
						if self.close_mode?
								self.close_mode
								sleep 1
						end
				end

				#保存模式设置
				def save_mode_change(time = 120)
						save_mode
						puts "sleeping #{time} seconds for changing router mode..."
						sleep time
				end

				#设置AP模式并保存
				def set_apmode
						select_apmode
						save_mode_change
				end

				#设置路由模式并保存
				def set_router_mode
						select_routermode
						save_mode_change
				end

				#打开设置模式页面->设置AP模式并保存
				def save_apmode(url)
						open_mode_page(url)
						set_apmode
				end

				#打开设置模式页面->设置路由模式并保存
				def save_routermode(url)
						open_mode_page(url)
						set_router_mode
				end

				#切换模式后重新登录
				def login_mode_change(usr, pw, url)
						puts "after change router mode relogin router"
						self.clear_cookies
						self.clear_cookies
						login_with(usr, pw, url)
				end

		end
end