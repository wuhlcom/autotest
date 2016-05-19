#encoding:utf-8
#router wifi detail info page
#author:wuhongliang
file_path1 =File.expand_path('../router_systatus_page', __FILE__)
require file_path1
module RouterPageObject
		module WIFI_Detail
				include PageObject
				in_iframe(src: @@ts_tag_wifidetail_src) do |frame|
						h2(:detail_title, id: "wifi_details", frame: frame)
						table(:list_wifi, id: @@ts_tag_wifitable, frame: frame)
						#无线SSID
						span(:ssid1_name, id: @@ts_tag_ssid1, frame: frame)
						span(:ssid2_name, id: @@ts_tag_ssid2, frame: frame)
						span(:ssid3_name, id: @@ts_tag_ssid3, frame: frame)
						span(:ssid4_name, id: @@ts_tag_ssid4, frame: frame)
						span(:ssid5_name, id: @@ts_tag_ssid5, frame: frame)
						span(:ssid6_name, id: @@ts_tag_ssid6, frame: frame)
						span(:ssid7_name, id: @@ts_tag_ssid7, frame: frame)
						span(:ssid8_name, id: @@ts_tag_ssid8, frame: frame)
						span(:ssid1_name_5g, id: @@ts_tag_ssid9, frame: frame)
						span(:ssid2_name_5g, id: @@ts_tag_ssid10, frame: frame)
						span(:ssid3_name_5g, id: @@ts_tag_ssid11, frame: frame)
						span(:ssid4_name_5g, id: @@ts_tag_ssid12, frame: frame)
						span(:ssid5_name_5g, id: @@ts_tag_ssid13, frame: frame)
						span(:ssid6_name_5g, id: @@ts_tag_ssid14, frame: frame)
						span(:ssid7_name_5g, id: @@ts_tag_ssid15, frame: frame)
						span(:ssid8_name_5g, id: @@ts_tag_ssid16, frame: frame)
						#无线加密模式
						span(:ssid1_pwmode, id: @@ts_tag_ssid1_pwmode, frame: frame)
						span(:ssid2_pwmode, id: @@ts_tag_ssid2_pwmode, frame: frame)
						span(:ssid3_pwmode, id: @@ts_tag_ssid3_pwmode, frame: frame)
						span(:ssid4_pwmode, id: @@ts_tag_ssid4_pwmode, frame: frame)
						span(:ssid5_pwmode, id: @@ts_tag_ssid5_pwmode, frame: frame)
						span(:ssid6_pwmode, id: @@ts_tag_ssid6_pwmode, frame: frame)
						span(:ssid7_pwmode, id: @@ts_tag_ssid7_pwmode, frame: frame)
						span(:ssid8_pwmode, id: @@ts_tag_ssid8_pwmode, frame: frame)
						span(:ssid1_pwmode_5g, id: @@ts_tag_ssid9_pwmode, frame: frame)
						span(:ssid2_pwmode_5g, id: @@ts_tag_ssid10_pwmode, frame: frame)
						span(:ssid3_pwmode_5g, id: @@ts_tag_ssid11_pwmode, frame: frame)
						span(:ssid4_pwmode_5g, id: @@ts_tag_ssid12_pwmode, frame: frame)
						span(:ssid5_pwmode_5g, id: @@ts_tag_ssid13_pwmode, frame: frame)
						span(:ssid6_pwmode_5g, id: @@ts_tag_ssid14_pwmode, frame: frame)
						span(:ssid7_pwmode_5g, id: @@ts_tag_ssid15_pwmode, frame: frame)
						span(:ssid8_pwmode_5g, id: @@ts_tag_ssid16_pwmode, frame: frame)
						#无线最大连接数
						span(:ssid1_linknum, id: @@ts_tag_ssid1_linknum, frame: frame)
						span(:ssid2_linknum, id: @@ts_tag_ssid2_linknum, frame: frame)
						span(:ssid3_linknum, id: @@ts_tag_ssid3_linknum, frame: frame)
						span(:ssid4_linknum, id: @@ts_tag_ssid4_linknum, frame: frame)
						span(:ssid5_linknum, id: @@ts_tag_ssid5_linknum, frame: frame)
						span(:ssid6_linknum, id: @@ts_tag_ssid6_linknum, frame: frame)
						span(:ssid7_linknum, id: @@ts_tag_ssid7_linknum, frame: frame)
						span(:ssid8_linknum, id: @@ts_tag_ssid8_linknum, frame: frame)
						span(:ssid1_linknum_5g, id: @@ts_tag_ssid9_linknum, frame: frame)
						span(:ssid2_linknum_5g, id: @@ts_tag_ssid10_linknum, frame: frame)
						span(:ssid3_linknum_5g, id: @@ts_tag_ssid11_linknum, frame: frame)
						span(:ssid4_linknum_5g, id: @@ts_tag_ssid12_linknum, frame: frame)
						span(:ssid5_linknum_5g, id: @@ts_tag_ssid13_linknum, frame: frame)
						span(:ssid6_linknum_5g, id: @@ts_tag_ssid14_linknum, frame: frame)
						span(:ssid7_linknum_5g, id: @@ts_tag_ssid15_linknum, frame: frame)
						span(:ssid8_linknum_5g, id: @@ts_tag_ssid16_linknum, frame: frame)
						#已连接数
						span(:ssid1_linked, id: @@ts_tag_ssid1_linked, frame: frame)
						span(:ssid2_linked, id: @@ts_tag_ssid2_linked, frame: frame)
						span(:ssid3_linked, id: @@ts_tag_ssid3_linked, frame: frame)
						span(:ssid4_linked, id: @@ts_tag_ssid4_linked, frame: frame)
						span(:ssid5_linked, id: @@ts_tag_ssid5_linked, frame: frame)
						span(:ssid6_linked, id: @@ts_tag_ssid6_linked, frame: frame)
						span(:ssid7_linked, id: @@ts_tag_ssid7_linked, frame: frame)
						span(:ssid8_linked, id: @@ts_tag_ssid8_linked, frame: frame)
						span(:ssid1_linked_5g, id: @@ts_tag_ssid9_linked, frame: frame)
						span(:ssid2_linked_5g, id: @@ts_tag_ssid10_linked, frame: frame)
						span(:ssid3_linked_5g, id: @@ts_tag_ssid11_linked, frame: frame)
						span(:ssid4_linked_5g, id: @@ts_tag_ssid12_linked, frame: frame)
						span(:ssid5_linked_5g, id: @@ts_tag_ssid13_linked, frame: frame)
						span(:ssid6_linked_5g, id: @@ts_tag_ssid14_linked, frame: frame)
						span(:ssid7_linked_5g, id: @@ts_tag_ssid15_linked, frame: frame)
						span(:ssid8_linked_5g, id: @@ts_tag_ssid16_linked, frame: frame)
						#无线工作频率
						span(:ssid1_rf, id: @@ts_tag_ssid1_rf, frame: frame)
						span(:ssid2_rf, id: @@ts_tag_ssid2_rf, frame: frame)
						span(:ssid3_rf, id: @@ts_tag_ssid3_rf, frame: frame)
						span(:ssid4_rf, id: @@ts_tag_ssid4_rf, frame: frame)
						span(:ssid5_rf, id: @@ts_tag_ssid5_rf, frame: frame)
						span(:ssid6_rf, id: @@ts_tag_ssid6_rf, frame: frame)
						span(:ssid7_rf, id: @@ts_tag_ssid7_rf, frame: frame)
						span(:ssid8_rf, id: @@ts_tag_ssid8_rf, frame: frame)
						span(:ssid1_rf_5g, id: @@ts_tag_ssid9_rf, frame: frame)
						span(:ssid2_rf_5g, id: @@ts_tag_ssid10_rf, frame: frame)
						span(:ssid3_rf_5g, id: @@ts_tag_ssid11_rf, frame: frame)
						span(:ssid4_rf_5g, id: @@ts_tag_ssid12_rf, frame: frame)
						span(:ssid5_rf_5g, id: @@ts_tag_ssid13_rf, frame: frame)
						span(:ssid6_rf_5g, id: @@ts_tag_ssid14_rf, frame: frame)
						span(:ssid7_rf_5g, id: @@ts_tag_ssid15_rf, frame: frame)
						span(:ssid8_rf_5g, id: @@ts_tag_ssid16_rf, frame: frame)
						#无线开关状态
						span(:ssid1_sw, id: @@ts_tag_ssid1_sw, frame: frame)
						span(:ssid2_sw, id: @@ts_tag_ssid2_sw, frame: frame)
						span(:ssid3_sw, id: @@ts_tag_ssid3_sw, frame: frame)
						span(:ssid4_sw, id: @@ts_tag_ssid4_sw, frame: frame)
						span(:ssid5_sw, id: @@ts_tag_ssid5_sw, frame: frame)
						span(:ssid6_sw, id: @@ts_tag_ssid6_sw, frame: frame)
						span(:ssid7_sw, id: @@ts_tag_ssid7_sw, frame: frame)
						span(:ssid8_sw, id: @@ts_tag_ssid8_sw, frame: frame)
						span(:ssid1_sw_5g, id: @@ts_tag_ssid9_sw, frame: frame)
						span(:ssid2_sw_5g, id: @@ts_tag_ssid10_sw, frame: frame)
						span(:ssid3_sw_5g, id: @@ts_tag_ssid11_sw, frame: frame)
						span(:ssid4_sw_5g, id: @@ts_tag_ssid12_sw, frame: frame)
						span(:ssid5_sw_5g, id: @@ts_tag_ssid13_sw, frame: frame)
						span(:ssid6_sw_5g, id: @@ts_tag_ssid14_sw, frame: frame)
						span(:ssid7_sw_5g, id: @@ts_tag_ssid15_sw, frame: frame)
						span(:ssid8_sw_5g, id: @@ts_tag_ssid16_sw, frame: frame)
				end
		end

		class WIFIDetail < SystatusPage
				include WIFI_Detail
				#打开WIFI详细信息页面
				def open_wifidetail_page(url)
						get_more_obj(url).click
						sleep 8
				end

				#table obj
				def table_obj
						self.list_wifi_element
				end

				def table_rows_obj
						table_obj.row_elements
				end

		end

end