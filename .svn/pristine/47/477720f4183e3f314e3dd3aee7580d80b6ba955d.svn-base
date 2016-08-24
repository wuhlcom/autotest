#encoding:utf-8
#change mac address by regedit
#wuhongliang 2015-11-16
require 'win32/registry'
require './wincmd'
class Win32Registry
		include WinCmd
		attr_reader :netcfg_instance_id

		def initialize(nicname)
				@nicname            =nicname
				@hkey_localmachine  = Win32::Registry::HKEY_LOCAL_MACHINE
				@key_all_access     = Win32::Registry::KEY_ALL_ACCESS
				instanceid          = net_cfg_rdr(@nicname)
				@netcfg_instance_id = instanceid[:netcfg_instance_id]
		end

		def find_add_nic_mac_reg(mac, attr="NetworkAddress")
				nic_reg={}
				@hkey_localmachine.open('system\currentcontrolset\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}', @key_all_access) do |reg|
						# each_key遍历{4D36E972-E325-11CE-BFC1-08002BE10318}所有子目录.reg.open打开子目录
						# 打开网卡GUID下的所有子目录
						reg.each_key do |subkey, _|
								next if subkey =~ /\D+/i
								reg.open(subkey, @key_all_access) do |subdir|
										instance_id_flag = false
										subdir.each { |attr|
												next if attr !="NetCfgInstanceId"
												instance_id_flag=true
												break if instance_id_flag
										}
										if instance_id_flag
												if subdir["NetCfgInstanceId"]==@netcfg_instance_id
														nic_reg[:reg_path]          =subdir.name
														nic_reg[:netcfg_instance_id]=@netcfg_instance_id
														nic_reg[:isfind]            =true
														add_mac_attr(subdir, mac, attr)
														nic_reg[attr.to_sym]=subdir[attr]
												end
										end
								end
						end
				end
				nic_reg
		end

		def add_mac_attr(reg, mac, attr="NetworkAddress")
				reg[attr]=mac
				reg[attr]
		end

		def make_mac_use(mac, attr="NetworkAddress")
				fail "Please input correct mac address" if mac !~/[0-9|A-F][048C][0-9|A-F]{10}/i
				modify_flag = false
				instanceid  ={}
				sta_enable_ ="enabled"
				sta_disable ="disabled"
				find_add_nic_mac_reg(mac, attr)
				netsh_if_setif_admin(@nicname, sta_disable)
				sleep 2
				netsh_if_setif_admin(@nicname, sta_enable_)
				sleep 5
				5.times do
						instanceid = net_cfg_rdr(@nicname)
						break unless instanceid.empty?
						sleep 5
				end
				if instanceid[:mac] = mac
						modify_flag=true
				end
				return modify_flag
		end

end


if __FILE__==$0
		mac     = "C86000C57268"
		mac1    = "C86000C57261"
		id      ="{94955C4F-2DDB-40CD-ADD4-907629727EBD}"
		nicname = "dut"
		# p Win32Registry.new.find_add_nic_mac_reg(id, value)
		reg     = Win32Registry.new(nicname)
		# p reg.find_add_nic_mac_reg(mac)
		# p reg.find_add_nic_mac_reg(mac1)
		p reg.make_mac_use(mac1)
end