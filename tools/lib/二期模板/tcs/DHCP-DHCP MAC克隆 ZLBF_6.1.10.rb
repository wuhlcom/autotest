#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_6.1.10", "level" => "P1", "auto" => "n"}

	def prepare

	end

	def process

		operate("1.进入MAC克隆页面，在DHCP Server开启抓包；") {

		}

		operate("2.选择“使用计算机MAC地址”查看地址文本框中显示MAC地址是否与登录主机的MAC地址一致，保存；") {

		}

		operate("3.在LAN PC端ping 服务器IP地址，抓包查看源MAC是否与主机的MAC地址一致；") {

		}

		operate("4.选择“使用指定MAC地址”，输入设置的MAC地址，保存；") {

		}

		operate("5.在LAN PC端ping 服务器IP地址，抓包查看源MAC与设置的MAC地址一致；") {

		}

		operate("6、选择“使用缺省地址”，保存；") {

		}

		operate("7.在LAN PC端ping 服务器IP地址，抓包查看源MAC是否与DUT 默认WAN口MAC地址一致；") {

		}

		operate("8、三种MAC地址克隆方式切换5次以上，DUT是否会出现异常；") {

		}


	end

	def clearup

	end

}
