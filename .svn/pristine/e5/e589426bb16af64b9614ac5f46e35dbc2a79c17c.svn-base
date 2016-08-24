# #encoding:utf-8
# #router lan set page tags
# #author:wuhongliang
# require './router_main_page'
# module RouterPageObject
# 		module Lan_Page
# 				include PageObject
# 				in_iframe(src: @@ts_tag_lan_src) do |frame|
# 						text_field(:lan_ip, id: @@ts_tag_lanip, frame: frame) #lan ip
# 						text_field(:lan_mask, id: @@ts_tag_lanmask, frame: frame) #lan mask
# 						text_field(:lan_startip, id: @@ts_tag_lanstart, frame: frame) #satrip
# 						text_field(:lan_endip, id: @@ts_tag_lanend, frame: frame) #end ip
# 						text_field(:dhcp_lease, id: @@ts_tag_dhcp_lease, frame: frame) #dhcp lease time
# 						button(:save_lanset, id: @@ts_tag_sbm, frame: frame) #save button
# 				end
# 		end
#
# 		class LanPage < MainPage
# 				include Lan_Page
#
# 				def lan_ip_set(ip)
# 						self.lan_ip=ip
# 				end
#
# 				def lan_mask_set(mask)
# 						self.lan_mask=mask
# 				end
#
# 				#num,ip地址最后一位
# 				def lan_startip_set(num)
# 						self.lan_startip =num
# 				end
#
# 				#num,ip地址最后一位
# 				def lan_endip_set(num)
# 						self.lan_endip=num
# 				end
#
# 				def dhcp_lease_set(time)
# 						self.dhcp_lease=time
# 				end
#
# 				#set lan ip then save
# 				def lan_ip(ip)
# 						lan_ip_set(ip)
# 						save_lanset
# 				end
#
# 				#set startip then save
# 				def lan_startip(num)
# 						lan_startip_set(num)
# 						save_lanset
# 				end
#
# 				#set end ip then save
# 				def lan_endip(num)
# 						lan_endip_set(num)
# 						save_lanset
# 				end
#
# 				#set dhcp lease time then save
# 				def dhcp_lease(time)
# 						dhcp_lease_set(time)
# 						save_lanset
# 				end
#
# 				#set startip and endip then save
# 				def dhcp_pool(startip, endip)
# 						lan_startip_set(startip)
# 						lan_endip_set(endip)
# 						save_lanset
# 				end
#
# 		end
#
# end