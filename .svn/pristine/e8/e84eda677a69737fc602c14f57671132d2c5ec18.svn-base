#router wifi detail info page
#author:wuhongliang
require './router_systatus_page'
module RouterPageObject
		module WIFI_Detail
				include PageObject
				in_iframe(src: @@ts_sys_status_src) do |frame|
						table(:list_wifi, id: @@ts_tag_wifitable, frame: frame)
						row(:first_wifi, text: "1", frame: frame)
						row(:second_wifi, text: "2", frame: frame)
						row(:third_wifi, text: "3", frame: frame)
						row(:fourth_wifi, text: "4", frame: frame)
				end
		end

		class WIFIDetail < SystatusPage

				def table_obj
						list_wifi_element
				end

				def table_rows_obj
						table_obj.row_elements
				end

		end

end