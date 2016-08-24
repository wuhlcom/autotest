#encoding:utf-8
#Use wireshark tool "dumpcap" capture packets
#other tools:tshark,wireshark,etc
# author : wuhongliang
# date   : 2015-9-7
require 'fileutils'
module HtmlTag
		module Wireshark
				#`dumpcap -D -M`
				# 1. \Device\NPF_{C3FC08EA-71A1-4DE5-957F-4B9648D96562}	Realtek PCIe GBE Family Controller	Local	0	192.168.10.63	network
				# 2. \Device\NPF_{A8A74058-4107-4A55-8B5B-729355A77D93}	Realtek USB NIC	USB	0	fe80::5ec:b022:c9a4:47a8,192.168.1.123,10.10.10.123,192.168.55.123,192.168.100.123	network
				# 3. \Device\NPF_{A9E73DF9-2768-459D-98F9-38146D60734B}	Microsoft	wireless	0	192.168.100.100	network
				# 4. \Device\NPF_{164020A5-332D-4495-856A-410929DD1928}	Astrill SSL VPN Adapter	Astrill SSL VPN	0	198.18.52.14	network
				#-return
				#   {"wireless"=>	{"index"=>"3",	 "ident"=>"\\Device\\NPF_{A9E73DF9-2768-459D-98F9-38146D60734B}",	 "desc"=>"Microsoft",	 "ip"=>["192.168.100.100"]}
				def dumpcap_intf
						rs      = `dumpcap -D -M`
						nic_arr = rs.split("\n")
						nic_hash={}
						nic_arr.each { |nic|
								m                               = /(\d+)\.\s+(\\Device.+\})\s+(.+)\s+(.+)\s+(\d+)\s+([a-f1-9].+)\s+(network)/i.match(nic)
								ips                             = m.captures[5].split(",")
								nic_hash[m.captures[3].downcase]={
										"index" => m.captures[0],
										"ident" => m.captures[1],
										"desc"  => m.captures[2],
										"ip"    => ips
								}
						}
						nic_hash
				end

				def dumpcap_intf_d
						rs      = `dumpcap -D`
						nic_arr = rs.split("\n")
						nic_hash={}
						nic_arr.each { |nic|
								m = /(\d+)\.\s+(\\Device.+\})\s+\((.+)\)/i.match(nic)
								m.captures
								nicname          = m.captures[2]
								nic_hash[nicname]={
										"index" => m.captures[0],
										"ident" => m.captures[1]
								}
						}
						nic_hash
				end

				def tshark_intf
						rs      = `tshark -D`
						nic_arr = rs.split("\n")
						nic_hash={}
						nic_arr.each { |nic|
								m = /(\d+)\.\s+(\\Device.+\})\s+\((.+)\)/i.match(nic)
								m.captures
								nicname          = m.captures[2]
								nic_hash[nicname]={
										"index" => m.captures[0],
										"ident" => m.captures[1]
								}
						}
						nic_hash
				end

				# Capture interface:
				#     -i <interface>   name or idx of interface (def: first non-loopback) or for remote_manage capturing, use one of these formats:
				# 	                    rpcap://<host>/<interface>
				#                       TCP@<host>:<port>
				#     -f <capture filter>      packet filter in libpcap filter syntax
				# Stop conditions:
				#     -c <packet count>        stop after n packets (def: infinite)
				#     -a <autostop cond.> ...  duration:NUM - stop after NUM seconds
				#                            filesize:NUM - stop this file after NUM KB
				#                             files:NUM - stop after NUM files
				# Output (files):
				# 		-w <filename>            name of file to save (def: tempfile)
				#     -g                       enable group read access on the output file(s)
				#     -b <ringbuffer opt.> ... duration:NUM - switch to next file after NUM secs
				#                              filesize:NUM - switch to next file after NUM KB
				#                             files:NUM - ringbuffer: replace after NUM files
				#     -n                       use pcapng format instead of pcap (default)
				#     -P                       use libpcap format instead of pcapng
				# dumpcap -i 1 -w "d:\ftp_test.pcap" -b filesize:50 -b files:10 -c 5
				# dumpcap -i 1 -w "d:\test1.pcap" -b filesize:50 -b files:10 -c 10 -f "ether src host 08:10:75:1b:5b:94"
				# dumpcap -i 1 -w "d:\test1.pcap" -b filesize:50 -b files:10 -a duration:10  -f "ether src host 08:10:75:1b:5b:94"
				# #抓包无过滤
				# C:\Users\zhilu1234>dumpcap -i 1 -w "d:\ftp_test.pcap" -b filesize:50 -b files:10 -c 5
				# Capturing on 'Local'
				# File: d:\test_00001_20150907135340.pcap
				# Packets captured: 5
				# Packets received/dropped on interface 'Local': 5/0 (pcap:0/dumpcap:0/flushed:0/ps_ifdrop:0) (100.0%)
				#
				# #抓包过滤
				# C:\>dumpcap -i 1 -w "d:\test1.pcap" -b filesize:50 -b files:10 -c 10 -f "ether src host 08:10:75:1b:5b:94"
				# Capturing on 'Local'
				# File: d:\test1_00001_20150907141039.pcap
				# Packets captured: 10
				# Packets received/dropped on interface 'Local': 10/0 (pcap:0/dumpcap:0/flushed:0/ps_ifdrop:0) (100.0%)
				# 抓包前先判断同名文件是否存在，
				# 如果存在则删除已经存在的同名文件
				# --params
				#
				# --return
				#    ""，由于无法捕获到console的输出，不能处理输出，默认返回值为""

				# captrue filter
				# stop type -a
				def dumpcap_a(save_path, intf=2, time_out=30, filter="", files=2, filesize=100)
						puts "#{self.to_s}->method_name:#{__method__}"
						file_dir = File.dirname(save_path)
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(save_path, ".*")
						Dir.glob("#{file_dir}/*.{pcap,pcapng}") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_rf(filename) #rm_rf要慎用
						}
						if filter==""
								rs = `dumpcap -i "#{intf}" -w "#{save_path}" -b "filesize:#{filesize}" -b "files:#{files}" -a "duration:#{time_out}"`
								# rs = %x(dumpcap -i "#{intf} -w "#{save_path}" -b filesize:#{filesize} -b files:#{files} -a duration:#{time_out})
						else
								rs = `dumpcap -i "#{intf}" -w "#{save_path}" -b "filesize:#{filesize}" -b "files:#{files}" -a "duration:#{time_out}" -f "#{filter}"`
						end
				end

				def dumpcap_c(save_path, intf=2, num=1, filter="", files=2, filesize=100)
						if filter==""
								rs = `dumpcap -i "#{intf} -w "#{save_path}" -b filesize:#{filesize} -b files:#{files} -c #{num}`
						else
								rs = `dumpcap -i "#{intf}" -w "#{save_path}" -b filesize:#{filesize} -b files:#{files} -c #{num} -f "#{filter}"`
						end
				end

				# capinfos [options] <infile> ...
				# 	Size infos:
				#     -c display the number of packets
				# 	  -s display the size of the file (in bytes)
				# 	  -d display the total length of all packets (in bytes)
				# 	  -l display the packet size limit (snapshot length)
				#
				# 	Time infos:
				# 			     -u display the capture duration (in seconds)
				# 	         -a display the capture start time
				# 	         -e display the capture end time
				#            -o display the capture file chronological status (True/False)
				#            -S display start and end times as seconds
				#读取指定的文件中的包的数量
				#如果有多个同名包文件只会读取第一个找到的文件，所以必须保证文件名唯一性
				#--return
				#  Num,返回抓到的包数
				def capinfos(filepath)
						file_dir  = File.dirname(filepath)
						file_name = File.basename(filepath, ".*")
						filename  =""
						Dir.glob("#{file_dir}/*.{pcap,pcapng}") { |file|
								if file=~/#{file_name}/
										filename=file
										break
								end
						}
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `capinfos -c -s -u #{filename}`
						print rs
						rs=~/Number of packets:\s+(\d+)\s*(\w*)/
						packets_unit = Regexp.last_match(2)
						packets_num  = Regexp.last_match(1)
						if packets_unit=~/k/i
								packets_num = packets_num.to_i*1000 #wireshark是以1000来换算不是以1000来换算
						elsif packets_unit=~/m/i
								packets_num = packets_num.to_i*1000*1000
						end
						packets_num.to_s
				end

				#
				# 	Usage: capinfos [options] <infile> ...
				#
				# 		General infos:
				# 				-t display the capture file type
				# 				-E display the capture file encapsulation
				# 				-I display the capture file interface information
				# 				-F display additional capture file information
				# 				-H display the SHA1, RMD160, and MD5 hashes of the file
				# 				-k display the capture comment
				#
				# 		Size infos:
				# 				-c display the number of packets
				# 				-s display the size of the file (in bytes)
				# 				-d display the total length of all packets (in bytes)
				# 				-l display the packet size limit (snapshot length)
				#
				# 				Time infos:
				# 				-u display the capture duration (in seconds)
				# 				-a display the capture start time
				# 				-e display the capture end time
				# 		    -o display the capture file chronological status (True/False)
				# 		    -S display start and end times as seconds
				#
				# Statistic infos:
				# 		          -y display average data rate (in bytes/sec)
				#               -i display average data rate (in bits/sec)
				#               -z display average packet size (in bytes)
				#               -x display average packet rate (in packets/sec)
				#
				# Output format:
				# 		       -L generate long report (default)
				#           -T generate table report
				#           -M display machine-readable values in long reports
				#
				# Table report options:
				# 		             -R generate header record (default)
				#                  -r do not generate header record
				#
				#                  -B separate infos with TAB character (default)
				#                  -m separate infos with comma (,) character
				#                  -b separate infos with SPACE character
				#
				#                  -N do not quote infos (default)
				#                  -q quote infos with single quotes (')
				#                  -Q quote infos with double quotes (")
				#
				# Miscellaneous:
				#    -h display this help and exit
				#   -C cancel processing if file open fails (default is to continue)
				#   -A generate all infos (default)
				#
				# Options are processed from left to right order with later options superceding
				# or adding to earlier options.
				#
				# If no options are given the default is to display all infos in long report
				# output format.
				#
				# wireshark 1.2.x.x
				# D:\>capinfos bd_test1.pcapng
				# File name:           bd_test1.pcapng
				# File type:           Wireshark/... - pcapng
				# File encapsulation:  Ethernet
				# Packet size limit:   file hdr: (not set)
				# Number of packets:   15 k
				# File size:           12 MB
				# Data size:           12 MB
				# Capture duration:    8 seconds
				# Start time:          Thu Oct 08 15:26:16 2015
				# End time:            Thu Oct 08 15:26:24 2015
				# Data byte rate:      1583 kBps
				# Data bit rate:       12 Mbps
				# Average packet size: 779.23 bytes
				# Average packet rate: 2031 packets/sec
				# SHA1:                8ce4504d906ed2de84540784f0285b3d8580b276
				# RIPEMD160:           5450a8870bd66d30969f62ec69e9e062ab224c27
				# MD5:                 3ba3cb41b8ed84f9fd8f233001b0bbd3
				# Strict time order:   True
				######################
				# wireshar 2.0.0.0
				# D:\ftpcaps>capinfos ftp_down1_00001_20151214220431.pcap
				# File name:           ftp_down1_00001_20151214220431.pcap
				# File type:           Wireshark/... - pcapng
				# File encapsulation:  Ethernet
				# File timestamp precision:  microseconds (6)
				# Packet size limit:   file hdr: (not set)
				# Number of packets:   37 k
				# File size:           58 MB
				# Data size:           56 MB
				# Capture duration:    4.649621 seconds
				# First packet time:   2015-12-14 22:04:31.402813
				# Last packet time:    2015-12-14 22:04:36.052434
				# Data byte rate:      12 MBps
				# Data bit rate:       97 Mbps
				# Average packet size: 1512.39 bytes
				# Average packet rate: 8091 packets/s
				# SHA1:                8e61044656e47e35ebdab0c00ad441de6b9697aa
				# RIPEMD160:           eb7f491ebdba2fdbe632eb641b2fbfa8275e3457
				# MD5:                 ba4bcd04e9b8d0c206654152d255066b
				# Strict time order:   True
				# Capture oper-sys:    64-bit Windows 7 Service Pack 1, build 7601
				# Capture application: Dumpcap (Wireshark) 2.0.0 (v2.0.0-0-g9a73b82 from master-2.0)
				# Number of interfaces in file: 1
				# Interface #0 info:
				# Name = \Device\NPF_{94955C4F-2DDB-40CD-ADD4-907629727EBD}
				# Description = NONE
				# Encapsulation = Ethernet (1/1 - ether)
				# Speed = 0
				# Capture length = 262144
				# FCS length = -1
				# Time precision = microseconds (6)
				# Time ticks per second = 1000000
				# Time resolution = 0x06
				# Filter string = not ether src C8:60:00:C5:72:68
				# Operating system = 64-bit Windows 7 Service Pack 1, build 7601
				# Comment = NONE
				# BPF filter length = 0
				# Number of stat entries = 0
				# Number of packets = 37622
				def capinfos_all(filepath)
						file_dir  = File.dirname(filepath)
						file_name = File.basename(filepath, ".*")
						filename  =""
						Dir.glob("#{file_dir}/*.{pcap,pcapng}") { |file|
								if file=~/#{file_name}/
										filename=file
										break
								end
						}
						puts "#{self.to_s}->method_name:#{__method__}"
						rs = `capinfos #{filename}`
						print rs
						summary ={}
						#capinfos: Can't open d:/t.pcap: No such file or directory
						if rs=~/No\s*such\s*file\s*or\s*directory/i
								puts "No such file or directory!"
								summary={packets_num: 0, file_size: 0, data_size: 0, duration: 0, byte_rate: 0, bit_rate: 0, packet_rate: 0}
						end
						# 	capinfos_summary=rs.split("\n")
						capinfos_summary = rs
						# Number of packets:   15 k
						capinfos_summary=~/Number of packets:\s+(\d+)\s*(\w*)/i
						packets_unit = Regexp.last_match(2)
						packets_num  = Regexp.last_match(1)
						if packets_unit=~/k/i
								packets_num = packets_num.to_i*1000
						elsif packets_unit=~/m/i
								packets_num = packets_num.to_i*1000*1000
						end
						packets_num          = 0 if packets_num.nil?
						summary[:packets_num]=packets_num

						# File size:           12 MB
						capinfos_summary=~/File size:\s+(\d+)\s*(\w*)/
						file_unit = Regexp.last_match(2)
						file_size = Regexp.last_match(1)
						if file_unit=~/KB|kB/
								file_size = file_size.to_i*1000
						elsif file_unit=~/MB/
								file_size = packets_num.to_i*1000*1000
						end
						file_size          = 0 if file_size.nil?
						summary[:file_size]=file_size #单位为B

						# Data size:           12 MB
						capinfos_summary=~/Data size:\s+(\d+)\s*(\w*)/i
						data_unit = Regexp.last_match(2)
						data_size = Regexp.last_match(1)
						if data_unit=~/KB|kB/
								data_size = data_size.to_i*1000
						elsif data_unit=~/MB/
								data_size = data_size.to_i*1000*1000
						end
						data_size          = 0 if data_size.nil?
						summary[:data_size]=data_size #单位为B

						# Capture duration:    8 seconds
						capinfos_summary=~/Capture duration:\s+(\d+)\s*(\w*)/i
						duration          = Regexp.last_match(1).to_i
						duration          = 0 if duration.nil?
						summary[:duration]=duration #单为s


						# Data byte rate:      1583 kBps
						# Data byte rate:      12 MBps
						capinfos_summary=~/Data byte rate:\s+(\d+)\s*(\w*)/i
						byte_unit = Regexp.last_match(2)
						byte_size = Regexp.last_match(1)
						if byte_unit=~/kB|KB/
								byte_rate = byte_size.to_i*1000
						elsif byte_unit=~/MB/
								byte_rate = byte_size.to_i*1000*1000
						end
						byte_rate          = 0 if byte_rate.nil?
						summary[:byte_rate]=byte_rate #单为Bps

						# Data bit rate:       12 Mbps
						capinfos_summary=~/Data bit rate:\s+(\d+)\s*(\w*)/i
						bit_unit = Regexp.last_match(2)
						bit_size = Regexp.last_match(1)
						if bit_unit=~/kb|Kb/
								bit_rate = bit_size.to_i*1000
						elsif bit_unit=~/Mb/
								bit_rate = bit_size.to_i*1000*1000
						end
						bit_rate          = 0 if bit_rate.nil?
						summary[:bit_rate]=bit_rate #单为bps

						# Average packet rate: 2031 packets/sec
						capinfos_summary=~/Average packet rate:\s+(\d+)/i
						packet_rate          = Regexp.last_match(1).to_i
						packet_rate          = 0 if packet_rate.nil?
						summary[:packet_rate]= packet_rate #单位为packets/sec
						summary
				end

				# 		Usage: tshark [options] ...
				#
				# 	 Capture interface:
				# 	-i <interface>           name or idx of interface (def: first non-loopback)
				# 	-f <capture filter>      packet filter in libpcap filter syntax
				# 	-s <snaplen>             packet snapshot length (def: 65535)
				# 	-p                       don't capture in promiscuous mode
				#   -I                       capture in monitor mode, if available
				#   -B <buffer size>         size of kernel buffer (def: 1MB)
				#   -y <link type>           link layer type (def: first appropriate)
				#   -D                       print list of interfaces and exit
				#   -L                       print list of link-layer types of iface and exit
				#
				# Capture stop conditions:
				#   -c <packet count>        stop after n packets (def: infinite)
				#   -a <autostop cond.> ...  duration:NUM - stop after NUM seconds
				#                            filesize:NUM - stop this file after NUM KB
				#                               files:NUM - stop after NUM files
				# Capture output:
				#   -b <ringbuffer opt.> ... duration:NUM - switch to next file after NUM secs
				#                            filesize:NUM - switch to next file after NUM KB
				#                               files:NUM - ringbuffer: replace after NUM files
				# RPCAP options:
				#   -A <user>:<password>     use RPCAP password authentication
				# Input file:
				#   -r <infile>              set the filename to read from (no stdin!)
				#
				# Processing:
				#   -2                       perform a two-pass analysis
				#   -R <read filter>         packet Read filter in Wireshark display filter syntax
				#   -Y <display filter>      packet displaY filter in Wireshark display filter
				#                            syntax
				#   -n                       disable all name resolutions (def: all enabled)
				#   -N <name resolve flags>  enable specific name resolution(s): "mntC"
				#   -d <layer_type>==<selector>,<decode_as_protocol> ...
				#                            "Decode As", see the man page for details
				#                            Example: tcp.port==8888,http
				#   -H <hosts file>          read a list of entries from a hosts file, which will
				#                            then be written to a capture file. (Implies -W n)
				# Output:
				#   -w <outfile|->           write packets to a pcap-format file named "outfile"
				#                            (or to the standard output for "-")
				#   -C <config profile>      start with specified configuration profile
				#   -F <output file type>    set the output file type, default is pcapng
				#                            an empty "-F" option will list the file types
				#   -V                       add output of packet tree        (Packet Details)
				#   -O <protocols>           Only show packet details of these protocols, comma
				#                            separated
				#   -P                       print packet summary even when writing to a file
				#   -S <separator>           the line separator to print between packets
				#   -x                       add output of hex and ASCII dump (Packet Bytes)
				#   -T pdml|ps|psml|text|fields
				#                            format of text output (def: text)
				#   -e <field>               field to print if -Tfields selected (e.g. tcp.port,
				#                            _ws.col.Info)
				#                            this option can be repeated to print multiple fields
				#   -E<fieldsoption>=<value> set options for output when -Tfields selected:
				#      header=y|n            switch headers on and off
				#      separator=/t|/s|<char> select tab, space, printable character as separator
				#      occurrence=f|l|a      print first, last or all occurrences of each field
				#      aggregator=,|/s|<char> select comma, space, printable character as
				#                            aggregator
				#      quote=d|s|n           select double, single, no quotes for values
				#   -t a|ad|d|dd|e|r|u|ud    output format of time stamps (def: r: rel. to first)
				#   -u s|hms                 output format of seconds (def: s: seconds)
				#   -l                       flush standard output after each packet
				#   -q                       be more quiet on stdout (e.g. when using statistics)
				#   -Q                       only log true errors to stderr (quieter than -q)
				#   -g                       enable group read access on the output file(s)
				#   -W n                     Save extra information in the file, if supported.
				#                            n = write network address resolution information
				#   -X <key>:<value>         eXtension options, see the man page for details
				#   -z <statistics>          various statistics, see the man page for details
				#   --capture-comment <comment>
				#                            add a capture comment to the newly created
				#                            output file (only for pcapng)
				# captrue filter
				# stop type -a duration设置抓包时间
				def tshark_a(save_path, intf=2, time_out=10, filter="", files=2, filesize=100)
						puts "#{self.to_s}->method_name:#{__method__}"
						file_dir = File.dirname(save_path)
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(save_path, ".*")
						Dir.glob("#{file_dir}/*.{pcap,pcapng}") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_rf(filename) #rm_rf要慎用
						}
						if filter==""
								rs = `tshark -i "#{intf}" -w "#{save_path}" -b "filesize:#{filesize}" -b "files:#{files}" -a "duration:#{time_out}"`
								# rs = %x(dumpcap -i "#{intf} -w "#{save_path}" -b filesize:#{filesize} -b files:#{files} -a duration:#{time_out})
						else
								rs = `tshark -i "#{intf}" -w "#{save_path}" -b "filesize:#{filesize}" -b "files:#{files}" -a "duration:#{time_out}" -f "#{filter}"`
						end
				end

				#
				#params
				#-save_path
				# --"d:/captures/xxx.pcapng"
				# --"d:/captures/xxx——22222.pcapng"
				#	要使抓的包保存在一个文件中@output_time必须大于或等于@cap_time
				#-ouput_time
				# 设置当抓包的时间超过ouput_time的值就会，超时抓的包保存到一个新文件中
				#-cap_time
				# 抓包多久后自动停止抓包
				def tshark_duration(save_path, intf="dut", output_time=10, cap_time=10, filter="")
						puts "#{self.to_s}->method_name:#{__method__}"
						file_dir = File.dirname(save_path)
						FileUtils.mkdir_p(file_dir) unless File.exists?(file_dir)
						file_name = File.basename(save_path, ".*")
						#先删除上次抓包的文件
						Dir.glob("#{file_dir}/*.{pcap,pcapng}") { |filename|
								filename=~/#{file_name}/ && FileUtils.rm_rf(filename) #rm_rf要慎用
						}
						if filter==""
								rs = `tshark -i "#{intf}" -w "#{save_path}" -b "duration:#{output_time}" -a "duration:#{cap_time}"`
						else
								rs = `tshark -i "#{intf}" -w "#{save_path}" -b "duration:#{output_time}" -a "duration:#{cap_time}" -f "#{filter}"`
						end
				end

				# 这里报文显示过滤，而不是抓包过滤
				# tshark -ni eth0 -Y "bootp.option.type == 53" -T fields -e frame.number -e frame.time -e ip.src -e ip.dst -e bootp.option.type -e bootp.ip.client -e xxxx
				# # tshark -ni eth0 -Y "dns && ip.dst == 202.96.134.133" -a duration:30 -T fields -e frame.number -e frame.time -e ip.src -e ip.dst -e dns.qry.name
				# dns.qry.name DNS请求的域名
				# dns.resp.addr DNS响应的地址
				# dns.a  域名对应的IP,addr
				# display filter reference
				#   https://www.wireshark.org/docs/dfref/
				# stop -a duration
				# -T 设置显示报文的格式
				#  text显示与cmd差不多,增加-V会详细信息
				#  ps显示以脚本格式显示 增加-V会详细信息
				#  psxl将脚本转为xml格式 增加-V会详细信息
				#  pdml详细xml格式,会显示每一条报文的详细信息 增加-V会详细信息
				#  field指定显示报文哪些字段与-e结合使用
				## args[:nic] = "dut";args[:nic]="2"
				## args[:filter] = "bootp.option.type==51" #wireshark display filter,not captures filter
				## args[:duration] = "30" #timeout for captrues
				# fields字符串第一种方式最外层一定要为单引号如下
				# args[:fields] = "-e 'eth.dst' -e 'eth.src'  -e 'ip.src' -e 'ip.dst' -e 'bootp.option.type' -e 'bootp.option.ip_address_lease_time'"
				# args[:fields]    ='-e eth.dst -e eth.src -e ip.src -e ip.dst'
				# args[:fields]    ="-e eth.dst -e eth.src  -e  ip.src -e ip.dst"
				def tshark_display_filter_fields(args)
						puts "#{self.to_s}->method_name:#{__method__}"
						rs_packes=[]
						if args[:nic].nil?|| args[:filter].nil?|| args[:duration].nil? ||args[:fields].nil?
								fail "param errors"
						end
						##{args[:field]}不要写在“”中
						rs = `tshark -ni "#{args[:nic]}" -Y "#{args[:filter]}" -T "fields" -a "duration:#{args[:duration]}" -e "frame.number" #{args[:fields]}`
						if rs==""
								puts "no packets captrued"
						else
								print "Packets captured:\n"
								print rs
								rs        =rs.gsub("\t", "->")
								rs_packes = rs.encode("GBK").split("\n")
						end
						rs_packes
				end

				def tshark_dhcp_lease_time
				end

				def remote_dumpcap

				end

				def syscall(*cmd)
						begin
								stdout, stderr, status = Open3.capture3(*cmd)
								status.success? && stdout.slice!(0..-(1 + $/.size)) # strip trailing eol
						rescue
						end
				end

		end
end
if __FILE__ == $0
		require 'pp'
		class Test
				include HtmlTag::Wireshark
		end
		t        = Test.new
		# File.open("d:/ftp_test.txt", "w") { |file|
		# 	$stdout.reopen(file)
		# }
		file_dir = "qos:/captures/"
		file_name= "remote_manage.pcapng"
		file_name= "tshark.pcapng"
		file_path=file_dir+file_name
		# pp t.dumpcap_intf
		# t.dumpcap_a(file_path, 2, 3)
		# t.capinfos(file_path)
		# print `dumpcap -D`
		filter   = 'ether src host 20:F4:1B:80:00:02'
		# t.dumpcap_a("d:/test_local.pcap", "dut", 5, filter)

		# p t.tshark_intf
		# p t.tshark_a(file_path, 1, 5, filter= files=2, filesize=100)
		#
		#
		# fields  ='-e "eth.dst" -e "eth.src"  -e "ip.src" -e "ip.dst" -e "bootp.option.type" -e "bootp.option.ip_address_lease_time"'
		# fields   ='-e "eth.dst" -e "eth.src"  -e "ip.src" -e "ip.dst"'
		# fields   ='-e eth.dst -e eth.src -e ip.src -e ip.dst'
		# fields   ="-e eth.dst -e eth.src  -e  ip.src -e ip.dst"
		# filter   = "ip"
		# filter   = "arp"
		# nic      = "dut"
		# duration = "2"
		# args     ={nic: nic, filter: filter, duration: duration, fields: fields}
		# p t.tshark_display_filter_fields(args)
		# print `tshark -ni "dut" -Y "not tcp.srcport == 3986" -T fields -a "duration:5" -e "frame.number" "#{fields}"`
		##############################################################################
		p t.capinfos_all("d:/captures/tshark_filezilla_ruby_00001_20151010160620.pcapng")
end