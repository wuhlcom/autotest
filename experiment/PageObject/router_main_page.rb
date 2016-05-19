#router main page tags
#get sub page object,such as wanset,lanset,advance,wifi,mode pages
#date:2016-02-24
#author:wuhongliang
require './router_login_page'
module RouterPageObject
		##定位主面的
		module Main_Page
				include PageObject
				span(:wan, id: @@ts_tag_netset)
				span(:mode, id: @@ts_tag_mode)
				span(:lan, id: @@ts_tag_lan)
				span(:wifi, id: @@ts_tag_wifi)
				span(:reboot, id: @@ts_tag_reboot)
				button(:reboot_confirm, id: @@ts_tag_reboot_confirm)
				link(:advance, id: @@ts_tag_options)
				link(:systatus, id: @@ts_sys_status)
		end

		class MainPage<LoginPage
				include Main_Page

				def wan_span_obj
						wan_element
				end

				def mode_span_obj
						mode_element
				end

				def lan_span_obj
						lan_element
				end

				def wifi_span_obj
						wifi_element
				end

				def advance_link_obj
						advance_element
				end

				def systatus_link_obj
						systatus_element
				end

		end
end
