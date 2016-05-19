#encoding:utf-8
require 'net/telnet'
module HtmlTag
		module RouterOS

				def init_routeros_obj(ip, usr="admin", pw="", timeout=10, wait_time=1, prompt=/[$%#>:] \z/n)
					puts "#{self.to_s}->method_name:#{__method__}"
						@routeros_prompt    = prompt
						@routeros_timeout   = timeout
						@routeros_wtime = wait_time
						@routerOS  = Net::Telnet::new("Host"     => ip, #登录地址
						                              "Timeout"  => timeout, #会话超时
						                              "Waittime" => wait_time, #等待响应
						                              "Prompt"   => prompt) #匹配响应
						@routerOS.login(usr, pw) { |str| print str }
					  puts
						return @routerOS
				end

				# 在string后添加换行符后,将其发送到远程主机上,并等待远程主机输出下一个提示match.
				# match的默认值取自是new中指定的"Prompt". timeout的默认值取自new中指定的"Timeout".
				# 若带块调用的话, 则把输出字符串当做参数来依次运行块的内容.
				# localhost.cmd("String"=>"top","Match"=>/CPU:/,"Timeout"=>2) { |c| print c }
				#cmd
				#  string, [usrname@devicename] view cmd,eg:"interface pri"
				#return
				#   string,cmd returns
				def routeros_send_cmd(cmd, timeout=10)
					puts "#{self.to_s}->method_name:#{__method__}"
						fail "#{cmd} type is #{cmd.class},command must be string!" unless cmd.kind_of?(String)
						fail "cmd is empty string,please check the params!" if cmd.empty?
						unless timeout != @routeros_timeout
								timeout=@routeros_timeout
						end
						cmd_return = @routerOS.cmd("String" => cmd, "Match" => @routeros_prompt, "Timeout" => timeout) { |str|
								print str
						}
						if cmd_return=~/syntax\s+error|bad\s+command/i
								fail "Command error!"
						end
						cmd_return
				end

				#remove the color string
				def remove_color(str)
						str =str.gsub(%r{\r|\e\[m\e\[\d+m|\e\[m|\[admin@.*\]\s*\>|\r}, "")
				end

				def remove_pri_color(cmd, str)
						str = str.gsub(%r{\r|\e\[m\e\[\d+m|\e\[m|\[admin@.*\]\s*\>|\r|#{cmd}}, "")
				end

				#parse the export str,return the
				#新增dhcp_server租约时间接卸 add by liluping 15/12/29
				def dhcp_server_pri_parse(cmd, str)
						puts "#{self.to_s}->method_name:#{__method__}"
						str_new = remove_pri_color(cmd, str)
						arr     = str_new.split("\n")
						arr.delete(" ")
						templet={}
						rs = arr.last.strip
						templet["lease-time"] = rs.split(/\s+/).last(2)[0]
						templet
				end

				def pptp_srv_exp_parse(str)
					puts "#{self.to_s}->method_name:#{__method__}"
						str    =remove_color(str)
						templet={}
						arr    = str.split("\n")
						arr.each { |element|
								next if element=~/^#/
								if element=~/\/(.+)/
										view           = Regexp.last_match(1).strip
										templet[:view] = view
								elsif element=~/(set.+)/
										templet[:set] =Regexp.last_match(1).strip
								end
						}
						templet
				end

				def pptp_srv_pri_parse(cmd, str)
					puts "#{self.to_s}->method_name:#{__method__}"
						str_new = remove_pri_color(cmd, str)
						arr     = str_new.split("\n")
						arr.delete(" ")
						templet={}
						arr.each { |item|
								/(?<key>.+)\s*:\s*(?<value>.+)/=~item
								templet[key.strip] =value.strip
						}
						templet
				end

				def pppoe_srv_pri_parse(cmd, str)
					puts "#{self.to_s}->method_name:#{__method__}"
						str =remove_pri_color(cmd, str)
						arr = str.split(/\s+?(.+?=.+?)\s+?/)
						arr.delete("")
						arr.delete("\n ")
						pppoe_pri={}
						arr.each { |x|
								x = x.strip
								case x
										when /\s*(\d+)\s+(service-name)=\"(.+)\"/
												pppoe_pri["index"]                   = Regexp.last_match(1).strip
												pppoe_pri[Regexp.last_match(2).strip]= Regexp.last_match(3).strip
										when /(\D+.+)=(.+)/
												pppoe_pri[Regexp.last_match(1).strip]= Regexp.last_match(2).strip
								end
						}
						pppoe_pri
				end

				# Flags: D - dynamic, X - disabled, R - running, S - slave
				# #     NAME                                TYPE         MTU L2MTU  MAX-L2MTU MAC-ADDRESS
				# 0  R  lan                                 ether       1500                  00:0C:29:4B:32:77
				# 1  R  wan                                 ether       1500                  00:0C:29:4B:32:6D
				# 2     l2tp-server                         l2tp-in
				# 3     pppoe-server                        pppoe-in
				# 4     pptp-server                         pptp-in
				#解析pri模板，需定义模板
				def pri_parse(str)

				end

				#-cmd
				#  string,export the configrations the parse it. eg "interface pptp-server server export"
				#return
				#  Hash,view and set cmd
				def pptp_srv_exp(cmd, timeout=10)
					puts "#{self.to_s}->method_name:#{__method__}"
						str = routeros_send_cmd(cmd, timeout)
						pptp_srv_exp_parse(str)
				end

				# show dhcp-server config
				#cmd
				#  string, ip dhcp-server pri
				#retrun
				#   hash
				def dhcp_srv_pri(cmd, timeout=10)
						puts "#{self.to_s}->method_name:#{__method__}"
						str = routeros_send_cmd(cmd, timeout)
						dhcp_server_pri_parse(cmd, str)
				end

 				# show pptp-server config
				#cmd
				#  string, interface pptp-server server pri				
				#retrun
				#   hash
				def pptp_srv_pri(cmd, timeout=10)
					puts "#{self.to_s}->method_name:#{__method__}"
						str = routeros_send_cmd(cmd, timeout)
						pptp_srv_pri_parse(cmd, str)
				end

				# show pppoe-server config
				#cmd
				#  string,"interface pppoe-server server pri"					
				#retrun
				#   hash
			
				def pppoe_srv_pri(cmd, timeout=10)
					puts "#{self.to_s}->method_name:#{__method__}"
						str = routeros_send_cmd(cmd, timeout)
						pppoe_srv_pri_parse(cmd, str)
				end

				#get the srv index  
				#set auth to the srv by index
				def pppoe_set_auth(cmd, timeout)
					puts "#{self.to_s}->method_name:#{__method__}"
						pppoe_pri = "interface pppoe-server server print"
						rs        = pppoe_srv_pri(pppoe_pri, timeout)
						cmd       = cmd+" #{rs["index"]}"
						routeros_send_cmd(cmd, timeout)
				end

				#disconnect routeros
				def logout_routeros
					puts "#{self.to_s}->method_name:#{__method__}"
						@routerOS.close
				end
			    #send quit to logout the routeros
				def quit_routeros
					puts "#{self.to_s}->method_name:#{__method__}"
					routeros_send_cmd("quit")
				end

		end
end
