# #encoding:utf-8
# nic_name="我"
# # nic_name="111"
# p nic_name_gbk=nic_name.encode("GBK")
# p state="enabled"
# # p state="disabled"
# p rs = `netsh interface set interface name="#{nic_name_gbk}" admin="#{state}"`
# p rs_utf8=rs.strip.encode("utf-8")
# true||fail("111")
# p ""&&true