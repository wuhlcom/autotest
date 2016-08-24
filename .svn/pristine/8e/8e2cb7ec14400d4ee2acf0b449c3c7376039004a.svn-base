# @echo off
# set /p mac=请输入新的MAC地址(如00-E0-4C-77-B0-A9):
# for /f >nul "skip=1 delims=[]" %%i in ('wmic nic where 'netconnectionid like "本地连接%%"' get caption') do set numnet=%%i
# set regpath=HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\%numnet:~-4%
# reg add "%regpath%" /v "NetworkAddress" /f >nul
# reg add "%regpath%\Ndi\Params\NetworkAddress" /v "ParamDesc" /d "NetworkAddress" /f >nul
# reg add "%regpath%\Ndi\Params\NetworkAddress" /v "default" /d "0" /f >nul
# reg add "%regpath%\Ndi\Params\NetworkAddress" /v "type" /d "enum" /f >nul
# reg add "%regpath%\Ndi\Params\NetworkAddress" /v "type" /d "enum" /f >nul
# reg delete "%regpath%\Ndi\Params\NetworkAddress" /v "optional" /f >nul
# reg delete "%regpath%\Ndi\Params\NetworkAddress" /v "UpperCase" /f >nul
# reg add "%regpath%\Ndi\Params\NetworkAddress\enum" /f >nul
# reg add "%regpath%\Ndi\Params\NetworkAddress\enum" /v "0" /d "%mac%" /f >nul

require 'win32/registry'
# Win32::Registry::HKEY_CURRENT_USER.open('SOFTWARE\foo') do |reg|
# 	 p value = reg['foo']                               # read a value
# 	 value = reg['foo', Win32::Registry::REG_SZ]      # read a value with type
# 	 type, value = reg.read('foo')                    # read a value
#    reg[""]=和write当不存subey,type,data会自动添加
#    reg['foo'] = 'bar'                               # write a value
#    reg['foo', Win32::Registry::REG_SZ] = 'bar'      # write a value with type
#    reg.write('foo', Win32::Registry::REG_SZ, 'bar') # write a value

# reg.each_value { |name, type, data| ... }        # Enumerate values
# reg.each_key { |key, wtime| ... }                # Enumerate subkeys
#
# reg.delete_value(name)                         # Delete a value
# reg.delete_key(name)                           # Delete a subkey
# reg.delete_key(name, true)                     # Delete a subkey recursively
# end

# Win32::Registry::HKEY_LOCAL_MACHINE.open('system\currentcontrolset\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}\007') do |reg|
# Win32::Registry::HKEY_LOCAL_MACHINE.open('system\currentcontrolset\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0007') do |reg|
# Win32::Registry::HKEY_LOCAL_MACHINE.open('system\currentcontrolset\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}') do |reg|
# 	p reg
# p reg.parent
# p reg.disposition
# 	p reg.name
# p reg.hkey
# p reg.keyname
#value就是当前目录的属性的键
# 	 reg.each { |x| p x }
#x 字键名，y子键类型，子键data
# reg.each_value { |x, y, z|
# 	next if x != "NetworkAddress"
# 	p x
# 	p y
# 	p z
# }
#key就是目录
# 	reg.keys { |key| p key }
# 		reg.each_key { |key| p key }
# 		p reg.keys
# 		p reg.each_key { |x, y|
# 				  p x
# 				  p y
# 		  }
#读取指定的属性data和类型返回为数组
#p reg.read("NetworkAddress")
# p reg["NetworkAddress"]
# create(subkey, desired = KEY_ALL_ACCESS, opt = REG_OPTION_RESERVED, &blk)
#创建子目录
# reg.create("test_mac") { |reg|
#创建属性
# p reg["mac"]="1111"
# p reg["mac"]="2222"
# }
# end
#打开网卡GUID目录{4D36E972-E325-11CE-BFC1-08002BE10318}
hklm_obj = Win32::Registry::HKEY_LOCAL_MACHINE
key_head = Win32::Registry::KEY_ALL_ACCESS
hklm_obj.open('system\currentcontrolset\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}', key_head) do |reg|
# 	# each_key遍历{4D36E972-E325-11CE-BFC1-08002BE10318}所有子目录.reg.open打开子目录
# 	# 打开网卡GUID下的所有子目录
		reg.each_key { |subkey, _|
				next if subkey=~/properties/i
				reg.open(subkey, key_head) { |subdir|
						# p subdir.name
						#  next if subdir!="DriverDesc"
						# # p subdir
						p subdir["DriverDesc"]
						p "#"*100
						subdir.each { |x| p x }
				}
		}
# reg.open("test_mac") { |x|
# 		p x["mac"]
# 		p x["mac"]="33333333"
# }
# p reg["NetworkAddress"]
# p reg["NetworkAddress"]="001100000001"
end

