#encoding:utf-8
#devcon manager the pc hardwares
# author : wuhongliang
# date   : 2015-9-8
# 设备控制台帮助：
# devcon.exe [-r] [-m:\\<machine>] <command> [<arg>...]
# -r 如果指定它，在命令完成后若需要则重新启动计算机。
# <machine> 是目标计算机的名称。
# <command> 是将要执行的命令（如下所示）。
# <arg>... 是命令需要的一个或多个参数。
# 要获取关于某一特定命令的帮助，请键入：devcon.exe help <command>
# 		                              classfilter          允许修改类别筛选程序。
# classes              列出所有设备安装类别。
# disable              禁用与指定的硬件或实例 ID 匹配的设备。
# driverfiles          列出针对设备安装的驱动程序文件。
# drivernodes          列出设备的所有驱动程序节点。
# enable               启用与指定的硬件或实例 ID 匹配的设备。
# find                 查找与指定的硬件或实例 ID 匹配的设备。
# findall              查找设备，包括那些未显示的设备。
# help                 显示此信息。
# hwids                列出设备的硬件 ID。
# install              手动安装设备。
# listclass            列出某一安装类别的所有设备。
# reboot               重新启动本地计算机。
# remove               删除与特定的硬件或实例 ID 匹配的设备。
# rescan               扫描以发现新的硬件。
# resources            列出设备的硬件资源。
# restart              重新启动与特定的硬件或实例 ID 匹配的设备。
# stack                列出预期的设备驱动程序堆栈。
# status               列出设备的运行状态。
# update               手动更新设备。
# UpdateNI             手动更新设备，无用户提示
# SetHwID              添加、删除和更改根枚举设备的硬件 ID 的顺序。
module HtmlTag
	module Devcon
		tool_dir = File.expand_path("../tools", File.dirname(__FILE__))
		DEVCON   =tool_dir+"/devcon.exe"

		def devcon_classes
			puts "#{self.to_s}->method_name:#{__method__}"
			rs           = `#{DEVCON} classes`
			classes      = rs.split("\n")
			classes_hash ={}
			classes_name =[]
			classes_desc =[]
			num          =0
			classes.each { |klass|
				case klass.strip
					when /\w+\s+(\d+)\s+\w+.+\./
						num=Regexp.last_match(1)
					when /(\w+.+)\:(.+)/
						classes_name<<Regexp.last_match(1).strip
						classes_desc<<Regexp.last_match(2).strip
					when /(\w+.+)\:/
						classes_name<<Regexp.last_match(1).strip
						classes_desc<<"no desc"
					else
						puts "no match"
				end
				classes_hash={class_num: num, class_names: classes_name, class_desces: classes_desc}
			}
			classes_hash
		end

		#list  devices of the specify class(es)
		#params
		#   klass,"net" or "net hdc"
		#
		def devcon_listclass(*klass)
			klass = klass.join(" ")
			rs    = `#{DEVCON} listclass #{klass}`
		end

		# if device removed,rescan can rediscover the device.
		# but the device name will change to the default
		# "dut" -> "本地连接
		def devcon_remove(id)
			puts "#{self.to_s}->method_name:#{__method__}"
		end

		def devcon_rescan
			rs = `#{DEVCON} rescan`
		end

		def devcon_restart(klass, id)
			rs = `#{DEVCON} restart ="#{klass}" "#{id}"`
			if rs=~/(\d+)\s+device\(s\)\s+restarted\./
				dev_num=Regexp.last_match(1)
			else
				false
			end
		end

		def devcon_status(klass, id)
			rs = `#{DEVCON} status ="#{klass}" "#{id}"`
			case rs
				when /Device\s+is\s+disabled/i
					"disabled"
				when /Driver\s*is\s*running/
					"running"
				else
					p rs
					"error"
			end

		end

		# Devcon Find Command
		# Finds devices with the specified hardware or instance ID. Valid on local and remote_manage computers.
		# devcon [-m:\\<machine>] find <id> [<id>...]
		# devcon [-m:\\<machine>] find =<class> [<id>...]
		#  <machine>    Specifies a remote_manage computer.
		#  <class>      Specifies a device setup class.
		# Examples of <id>:
		# *              - All devices
		# ISAPNP\PNP0501 - Hardware ID
		# *PNP*          - Hardware ID with wildcards  (* matches anything)
		# @ISAPNP\*\*    - Instance ID with wildcards  (@ prefixes instance ID)
		# '*PNP0501      - Hardware ID with apostrophe (' prefixes literal match - matches exactly as typed,
		# 		                                                                                                                                                                  including the asterisk.)
		# 	 Device entries have the format <instance>: <descr>
		# 		where <instance> is the unique instance of the device and <descr> is the device description.
		def devcon_find(klass, id)
			rs = `#{DEVCON} find ="#{klass}" "#{id}"`
			if rs=~/(\d+)\s+matching\s+device\(s\)\s+found\./
				dev_num=Regexp.last_match(1)
			else
				false
			end
		end

		def devcon_enable(klass, id)
			rs = `#{DEVCON} enable ="#{klass}" "#{id}"`
			if rs=~/(\d+)\s+device\(s\)\s+are\s+enabled\./
				dev_num=Regexp.last_match(1)
			else
				puts rs
				false
			end
		end

		def devcon_disable(klass, id)
			rs = `#{DEVCON} disable ="#{klass}" "#{id}"`
			if rs=~/(\d+)\s+device\(s\)\s+disabled\./
				dev_num=Regexp.last_match(1)
			else
				puts rs
				false
			end
		end

	end
end

if __FILE__==$0
	require "pp"
	class Test
		include HtmlTag::Devcon
	end
	Test.new.devcon_classes
	# p Test.new.devcon_find("net", "usb\\vid*")
	# p Test.new.devcon_disable("net", "usb\\vid*")
	# p Test.new.devcon_enable("net", "usb\\vid*")
	# p Test.new.devcon_status("net", "usb\\vid*")
	p Test.new.devcon_listclass(["net", "hdc"])
end