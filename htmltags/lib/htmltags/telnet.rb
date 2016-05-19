#encoding:utf-8
require 'net/telnet'

module HtmlTag

		module Telnet
				def telnet_init(url, user="admin", password="admin")
						puts "#{self.to_s}->method_name:#{__method__}"
						@localhost = Net::Telnet::new("Host"     => url,
						                              "Timeout"  => 10,
						                              "Waittime" => 2,
						                              "Prompt"   => /[$%#>:] \z|(\[N\/y\])/n)
						@localhost.login(user, password) { |c| print c }
						puts
						return @localhost
				end

				def telnet_send_cmd(cmd, timeout=10)
						puts "#{self.to_s}->method_name:#{__method__}"
						fail "#{cmd} type is #{cmd.class},command must be string!" unless cmd.kind_of?(String)
						fail "cmd is empty string,please check the params!" if cmd.empty?
						cmd_return = @localhost.cmd("String" => cmd, "Timeout" => timeout) { |c| print c }
						puts
						# if cmd_return=~/not\s*found|syntax\s+error|bad\s+command/i
						# 		fail "Command error!"
						# end
						cmd_return
				end

				#解析"uptime"
				def parse_run_time(str)
						puts "#{self.to_s}->method_name:#{__method__}"
						arr      = str.split("\n")
						par_time = ""
						arr.each do |item|
								next if (item=~/^#/ || item=~/uptime/)
								par_time = item.slice(/up\s*(.+?),/i, 1)
								if par_time == "0 min"
										par_time = item.slice(/\d+:\d+:(\d+)/i, 1) + " secs"
								end
						end
						par_time
				end

				#解析"cat /proc/meminfo"
				def parse_memory_info(str)
						puts "#{self.to_s}->method_name:#{__method__}"
						templet  = {}
						memtotal = ""
						memfree  = ""
						cached   = ""
						arr      = str.split("\n")
						arr.each do |item|
								if item =~ /^memtotal\s*:\s*(\d+)/i
										memtotal           = $1
										templet[:memtotal] = memtotal
										next
								end

								if item =~ /^memfree\s*:\s*(\d+)/i
										memfree           = $1
										templet[:memfree] = memfree
										next
								end

								if item =~ /^cached\s*:\s*(\d+)/i
										cached           = $1
										templet[:cached] = cached
										next
								end
						end
						templet
				end

				#执行"cat /proc/meminfo"
				def exp_memory_info(cmd="cat /proc/meminfo")
						puts "#{self.to_s}->method_name:#{__method__}"
						str = telnet_send_cmd(cmd)
						parse_memory_info(str)
				end

				#执行"uptime"
				def exp_run_time(cmd="uptime")
						puts "#{self.to_s}->method_name:#{__method__}"
						str = telnet_send_cmd(cmd)
						parse_run_time(str)
				end

				#执行”reboot“
				def exp_reboot(cmd="reboot")
						puts "#{self.to_s}->method_name:#{__method__}"
						telnet_send_cmd(cmd)
				end

				#执行”ralink_init clear 2860“恢复出厂设置
				# Usage:
				#     ralink_init <command> [<platform>] [<file>]
				#
				# command:
				#     rt2860_nvram_show - display rt2860 values in nvram
				#     rtdev_nvram_show   - display 2nd ralink device values in nvram
				#     uboot_nvram_show - display uboot parameter values
				#     show    - display values in nvram for <platform>
				#     gen     - generate config file from nvram for <platform>
				#     renew   - replace nvram values for <platform> with <file>
				#     clear   - clear all entries in nvram for <platform>
				# platform:
				#     2860    - rt2860
				#     rtdev    - 2nd ralink device
				#     uboot    - uboot parameter
				# file:
				#     - file name for renew command
				######################################################################################
				###################### 统一平台恢复出厂设置使用命令： firstboot  #####################
				# def exp_ralink_init(cmd="ralink_init clear 2860")
				def exp_ralink_init(cmd="firstboot", cmd_f="y", time=120)
						puts "#{self.to_s}->method_name:#{__method__}"
						telnet_send_cmd(cmd)
						sleep 1
						telnet_send_cmd(cmd_f)
						sleep 1
						begin
								#重启后系统会断开连接导致telnet报超时错误，为了让程序继续执行，将其放在异常捕获中
								exp_reboot
						rescue => ex
								p ex.message.to_s
						end
						puts
						puts "sleep #{time} seconds for rebooting..."
						sleep time
				end
		end
end


if __FILE__==$0
		# class Test
		#   include HtmlTag::Telnet
		# end
		# t = Test.new
		# p t.telnet("192.168.100.1","admin","admin","cat /proc/meminfo")
		include HtmlTag::Telnet
		# p telnet("192.168.100.1", "cat /proc/meminfo", "admin", "admin")
		telnet_init("192.168.100.1", "root", "zl4321")
		# print telnet_send_cmd("cat /proc/meminfo")
		# p "==========================="
		# print exp_run_time("uptime")
		# print "\n"
		# print exp_memory_info("cat /proc/meminfo")
		# print "\n"
		exp_ralink_init
		# exp_reboot
		# p "==========================="
end
