#encoding:utf-8
=begin
rs = `netsh interface show interface`
p rs.encoding
print rs
#转码
rs_utf8 = rs.encode("utf-8")
puts
#去除和两头空白（\n）-----------------
p rs_utf8
p rs_utf8 =rs_utf8.strip.gsub(/\n-+\n/, "\n")
rs_utf8_arr=rs_utf8.split("\n")
h={}
rs_utf8_arr.each_with_index { |arr, index|
  next if index==0
  admin_state1="已启用"
  admin_state2="已禁用"
  state1="已连接"
  state2="已断开连接"
  type="专用"
  p arr.encode("GBK")
  p arr
  m=/(\p{Han}+)\s+(\p{Han}+)\s+(\p{Han}+)\s+(\p{Han}+|\w+)\s*/u.match(arr)
  m_arr=m.captures
  if m_arr[0]=~/#{admin_state1}/
    admin_state="enabled"
  elsif m_arr[0]=~/#{admin_state2}/
    admin_state="disenabled"
  else
    admin_state= m_arr[0]
  end

  if m_arr[1]=~/#{state1}/
    state="connected"
  elsif m_arr[1]=~/#{state2}/
    state="disconnected"
  else
    state=m_arr[1]
  end


  if m_arr[2]=~/#{type}/
    card_type="dedicated"
  else
    card_type=m_arr[2]
  end

  h[m_arr[-1]]={:admin_state => admin_state, :state => state, :type => card_type}

  # p arr=~/(\p{Han}+)\s+(\p{Han}+)\s+(\p{Han}+)\s+[(\p{Han}+)|(\w+)]\s*/u
}
=end

=begin
s ="我"
# p s[0]
# p s=~/^u/
# p s=~/^\u/
# p s=~/^\\u/u
# p s=~/^\u/u


s_GBK=s.encode("GBK")
# 我(网卡的名字)
# 种类:     专用
# 管理状态: 已启用
# 连接状态: 已连接
print rs = `netsh interface show interface #{s_GBK} `
rs.strip.split("\n")
rs_utf8= rs.strip.encode("utf-8")
h2={}
nic_arr=rs_utf8.split("\n")
admin_state1="已启用"
admin_state2="已禁用"
state1="已连接"
state2="已断开连接"
type="专用"

if nic_arr[1]=~/#{type}/
  card_type="dedicated"
else
  card_type=nic_arr[1]
end

if nic_arr[2]=~/#{admin_state1}/
  admin_state="enabled"
elsif nic_arr[2]=~/#{admin_state2}/
  admin_state="disenabled"
else
  admin_state= nic_arr[2]
end

if nic_arr[3]=~/#{state1}/
  state="connected"
elsif nic_arr[3]=~/#{state2}/
  state="disconnected"
else
  state=nic_arr[3]
end

h2[nic_arr[0]]={:admin_state => admin_state, :state => state, :type => card_type}
p h2
=end


p s1="我".size
p "1"=~/^.$/u
p "1"=~/^.$/