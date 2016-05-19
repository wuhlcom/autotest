require 'drb/drb'
SERVER_URI="druby://192.168.10.73:8787"
DRb.start_service
wifi     = DRbObject.new_with_uri(SERVER_URI)
# puts wlan.connect("WIFI_002A11","12345678","1")
ssid_name="zhilu"
# ssid_name="WIFI_002A11"
ssid_name="WIFI_039E99"
nicname  ="wireless"
passwd   =""
passwd   ="12345678"
# pwfile="#{nicname}-#{ssid_name}.xml"
puts wifi.connect(ssid_name, "1", passwd)
# p wifi.ip_release(nicname)
# p wifi.ip_renew(nicname)
# p wifi.ipconfig
# p rs = wifi.netsh_if_shif(nicname)
# p rs = wifi.ipconfig("all")
# args={type: "addresses", nicname: nicname}
# p wifi.net_if_ip_show(args)
# rs         = @wifi.connect(@ssid_name,@tc_wifi_flag)