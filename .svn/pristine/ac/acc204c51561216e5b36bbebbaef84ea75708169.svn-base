#encoding:utf-8
#router mode set page
#author:wuhongliang
require './router_main_page'
module RouterPageObject
		module Mode_Page
				include PageObject
				in_iframe(src: @@ts_tag_routermode) do |frame|
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
				end
		end

		class ModePage
				include Mode_Page
		end
end