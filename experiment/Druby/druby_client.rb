require 'drb/drb'
require 'pp'
SERVER_URI="druby://192.168.10.73:8787"
SERVER_URI="druby://192.168.55.56:8787"
DRb.start_service
wifi = DRbObject.new_with_uri(SERVER_URI)
# puts wlan.connect("WIFI_002A11","12345678","1")
ssid_name="zhilu"
# ssid_name="WIFI_002A11"
nicname="wireless"
passwd=""
# passwd="12345678"
# pwfile="#{nicname}-#{ssid_name}.xml"
# puts wifi.connect(ssid_name,passwd,pwfile,"1")
# p wifi.ip_release(nicname)
# p wifi.ip_renew(nicname)
# p wifi.ipconfig
# p rs = wifi.netsh_if_shif(nicname)
# p rs = wifi.ipconfig("all")

# args={type:"addresses",nicname:nicname}
# p wifi.net_if_ip_show(args)
pp wifi.show_interfaces