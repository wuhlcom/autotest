require 'htmltags'
include HtmlTag::Wireshark
include HtmlTag::WinCmd
require 'net/ftp'
require 'pp'

@tc_wait_time       = 2
@tc_ftp_time        = 30
@tc_qos_time        = 5
@tc_net_time        = 35
@tc_bandwidth_total = 100000
@tc_bandwidth_limit = 1024
@tc_bandwidth_max   = 102400
@tc_cap_path1       = "D:/ftpcaps/ftp_down1.pcap"
@tc_cap_path2       = "D:/ftpcaps/ftp_down2.pcap"
@tc_cap_path3       = "D:/ftpcaps/ftp_down3.pcap"
@tc_output_time     = 5
@tc_cap_time        = 5
@ts_nicname         = "dut"
@ts_ipconf_all      = "all"

#ftp params
@ts_wan_client_ip = "10.10.10.57"
@ts_ftp_usr        = "admin"
@ts_ftp_pw         = "admin"
@ts_ftp_srv_file   = "QOS_TEST2.zip"
@ts_ftp_download   = "D:/ftpdownloads/#{@ts_ftp_srv_file}"
@ts_ftp_block      = 32768

rs                  = ipconfig(@ts_ipconf_all)
pc_mac              = rs[@ts_nicname][:mac]
p @tc_ip_addr = rs[@ts_nicname][:ip][0]
@tc_ftp_filter = "not ether src #{pc_mac}"

#��ftp���ط����߳��У��������ʼ���
#ftp���غ�ץ���ֱ�ʹ�ò�ͬ�ļ��������ʾͻ�ﵽ12MBps
#���߳�������һ��`cmd`���̣��ͻᵥ�����ɸ�������main�Ľ���
# t              = Thread.new() do
# 	`ruby ftp_client_2.rb #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block}`
# end

#ʹ��spawn��������,��������
# p pid = Process.spawn("ruby e:/Automation/experiment/ftp/ftp_client_2.rb #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block}", STDERR => :out)
p pid = Process.spawn("ruby e:/autotest/experiment/ftp/ftp_client.rb #{@ts_wan_client_ip} #{@ts_ftp_usr} #{@ts_ftp_pw} #{@ts_ftp_srv_file} #{@ts_ftp_download} #{@ts_ftp_block} 'get'")
# p pid =  Process.spawn("ruby e:/Automation/experiment/ftp/ftp_client_1.rb",STDERR=>:out)
# Process.fork {
# exec(s)
# # }

 sleep @tc_ftp_time
 tshark_duration(@tc_cap_path1, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
# sleep @tc_cap_time
# tshark_duration(@tc_cap_path2, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
# sleep @tc_cap_time
# tshark_duration(@tc_cap_path3, @ts_nicname, @tc_output_time, @tc_cap_time, @tc_ftp_filter)
# t.kill if t.alive?
p Process.detach(pid)
p Process.detach(pid).alive?
# sleep 15
# p Process.detach(pid)
# p Process.detach(pid).alive?
if Process.detach(pid).alive? #ץ�����ɱ������
	p Process.kill(9, pid)
end
# p Process.abort("ddd")
# p Process.exit!(pid)
# capinfos_all(@tc_cap_path1)
# capinfos_all(@tc_cap_path2)
# capinfos_all(@tc_cap_path3)