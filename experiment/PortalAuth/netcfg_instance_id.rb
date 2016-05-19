#encoding:utf-8
#nic guid
require './wincmd'
class NetcfgInstanceID
		include WinCmd
		def net_cfg_rdr
				`net config rdr`
		end

		def parse_instanceid_mac(nicname)
				ip_info  = ipconfig("all")
				mac_addr = ip_info[nicname][:mac]
				nic_mac  = mac_addr.delete("-")
				rs       = net_cfg_rdr
				rs_utf8  = rs.encode("UTF-8")
				arr      = rs_utf8.split("\n")
				nic_hash ={}
				arr.each { |item|
						item = item.strip
						next if item !~ /NetBT_Tcpip_/i
						%r{NetBT_Tcpip_(?<netcfg_instance_id>\{.+\})\s*\((?<mac_address>\w+)\)}i=~item
						if mac_address==nic_mac
								nic_hash = {netcfg_instance_id: netcfg_instance_id, mac: mac_address}
								break
						end
				}
				nic_hash
		end
end

if __FILE__==$0
		p rs = NetcfgInstanceID.new.parse_instanceid_mac("dut")
end