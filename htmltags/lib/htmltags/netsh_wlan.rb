#encoding:utf-8
# 封装的命令
# netsh wlan show all
## Network type            : 结构
# 身份验证                : WPA2 - 个人
# 加密                    : CCMP
# BSSID 1               : 6c:72:20:cc:09:6d
# 信号               : 100%
# 无线电类型         : 802.11n
# 频道               : 6
# 基本速率(Mbps)     : 1 2 5.5 11
# 其他速率(Mbps)     : 6 9 12 18 24 36 48 54
# BSSID 2               : e8:de:27:f7:93:b5
# 信号               : 100%
# 无线电类型         : 802.11n
# 频道               : 6
# 基本速率(Mbps)     : 1 2 5.5 11
# 其他速率(Mbps)     : 6 9 12 18 24 36 48 54
# BSSID 3               : e8:de:27:f7:93:b6
# 信号               : 90%
# 无线电类型         : 802.11n
# 频道               : 153
# 基本速率(Mbps)     : 6 12 24
# 其他速率(Mbps)     : 9 18 36 48 54
# author : wuhongliang
# date   : 2016-3-30

module HtmlTag

		module NetshWlan

				def wlan_show_all
					rs = `netsh wlan show all`.encode('utf-8', {:invalid => :replace, :undef => :replace, :replace => '?'})
				end

				#分离ssid信息和无线网卡信息,返回所有ssid信息
				def split_ssid_nic
						rs       = wlan_show_all
					ssid_arr = rs.split(/显示网络模式\sMODE=BSSID/)[1].split(/SSID\s\d+\s:/)
				end

				#分割SSID信信息中bssid信息
				def split_ssid_bss(bssinfo)
						bss_arr = bssinfo.split("BSSID")
				end

				#解析ssid信息部分
				def parse_ssid(ssidinfo)
						ssid = ssidinfo[0].strip unless ssidinfo[0].nil?
						if /Network\s+type\s+:\s+(?<struct>.+)/u=~ssidinfo[1]
								if struct=~/\u7ED3\u6784/ #结构式
										network_type = "struct"
								else
										network_type=struct
								end
						end

						# "    \u8EAB\u4EFD\u9A8C\u8BC1                : WPA2 - \u4E2A\u4EBA"
						if /身份验证\s+:\s+(?<identify>.+)/=~ssidinfo[2]
								if identify.strip=="WPA2 - \u4E2A\u4EBA" #WPA2 - 个人
										identify = "WPA2PSK"
								elsif identify.strip=="WPA - \u4E2A\u4EBA" #WPA - 个人
										identify = "WPAPSK"
								elsif identify.strip=="\u5F00\u653E\u5F0F" #开放式
										identify="OPEN"
								else
										identify=identify
								end
						end

						/\u52A0\u5BC6\s+:\s+(?<aumode>.+)/=~ssidinfo[3]
						if aumode.strip=="\u65E0" #无
								aumode ="NONE"
						end
						ssid_hash = {ssid: ssid.strip, network_type: network_type.strip, identify: identify.strip, au_mode: aumode.strip}
				end

				#解析Bssid信息
				def parse_bssid(item)
						item_arr = item.split("\n")
						/\s*(?<bssid>\d+)\s+:/ =~ item_arr[0]
						/\d+\s+:\s+(?<mac>[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2})/i =~ item_arr[0]
						/\s+\u4FE1\u53F7\s+:\s+(?<signal>.+)/i =~ item_arr[1]
						/\s+\u65E0\u7EBF\u7535\u7C7B\u578B\s+:\s+(?<wireless>.+)/i =~ item_arr[2]
						/\s+\u9891\u9053\s+:\s+(?<channel>.+)/i =~ item_arr[3]
						/\s+\u57FA\u672C\u901F\u7387\(Mbps\)\s+:\s+(?<basic_speed>.+)/i =~ item_arr[4]
						/\s+\u5176\u4ED6\u901F\u7387\(Mbps\)\s+:\s+(?<other_speed>.+)/i =~ item_arr[5]						
						other_speed = "" if other_speed.nil?					
						bssid_hash = {
								bssid:        bssid.strip,
								mac:          mac.strip,
								signal:       signal.strip,
								wirelss_type: wireless.strip,
								channel:      channel.strip,
								basic_speed:  basic_speed.strip,
								other_speed:  other_speed.strip
						}
				end

				#返回数组
				#格式为 [{:ssid=>"xx",:au_mode=>"xx",:bssids=>[{:bssid=>x,:mac=>x....chanel=>x},...{:bssid=>y,:mac=>y....chanel=>y}]}.....{..}]
				#eg:
				# [{:ssid=>"wifipublicfree",
				#   :network_type=>"struct",
				#   :identify=>"WPA2PSK",
				#   :au_mode=>"CCMP",
				#   :bssids=>
				# 		  [{:bssid=>"1",
				# 		    :mac=>"78:a3:51:01:27:58",
				# 		    :signal=>"100%",
				# 		    :wirelss_type=>"802.11n",
				# 		    :channel=>"1",
				# 		    :basic_speed=>"1 2 5.5 11",
				# 		    :other_speed=>"6 9 12 18 24 36 48 54"},
				# 		   {:bssid=>"2",
				# 		    :mac=>"78:a3:51:01:2a:70",
				# 		    :signal=>"100%",
				# 		    :wirelss_type=>"802.11n",
				# 		    :channel=>"3",
				# 		    :basic_speed=>"1 2 5.5 11",
				# 		    :other_speed=>"6 9 12 18 24 36 48 54"}]},
				#  {:ssid=>"Wireless1",
				#   :network_type=>"struct",
				#   :identify=>"OPEN",
				#   :au_mode=>"NONE",
				#   :bssids=>
				# 		  [{:bssid=>"1",
				# 		    :mac=>"7a:a3:51:00:27:58",
				# 		    :signal=>"100%",
				# 		    :wirelss_type=>"802.11n",
				# 		    :channel=>"1",
				# 		    :basic_speed=>"1 2 5.5 11",
				# 		    :other_speed=>"6 9 12 18 24 36 48 54"},
				# 		   {:bssid=>"2",
				# 		    :mac=>"7a:a3:51:00:2a:28",
				# 		    :signal=>"74%",
				# 		    :wirelss_type=>"802.11n",
				# 		    :channel=>"1",
				# 		    :basic_speed=>"1 2 5.5 11",
				# 		    :other_speed=>"6 9 12 18 24 36 48 54"}]},
				#  {:ssid=>"Wireless3",
				#   :network_type=>"struct",
				#   :identify=>"WPA2PSK",
				#   :au_mode=>"CCMP",
				#   :bssids=>...}
				#]
				def netsh_wlsh_all
						bssinfo   = split_ssid_nic
						ssids_hash=[]
						bssinfo.each_with_index do |bss, idx|
								next if idx ==0
								bssids_arr=[]
								arr_bss   = split_ssid_bss(bss)
								ssid_hash = parse_ssid(arr_bss[0].split("\n"))
								arr_bss.each_with_index do |item, index|
										next if index == 0									
										bssids_arr << parse_bssid(item)
								end
								bssids_hash ={bssids: bssids_arr}
								ssid_hash.merge!(bssids_hash)
								ssids_hash<<ssid_hash
						end
						ssids_hash
				end

				#获取指定SSID的信道
				def get_wlan_channel(ssid)
						flag = false
						3.times do
								rs   = netsh_wlsh_all
								rs.each do |item|
										item.each do |k, v|
												if v == ssid
														puts "bssids info:#{item[:bssids]}"
														channel = item[:bssids][0][:channel]
														if channel =~/\d+/
																flag = true
																return channel
														end
												end
										end
								end
								sleep 10
						end
						unless flag
								return "can't find ssid #{ssid}!"
						end
				end
		end
end