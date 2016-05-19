#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
testcase {
	attr = {"id" => "ZLBF_18.1.2", "level" => "P1", "auto" => "n"}

	def prepare

	end

	def process

		operate("1、在AP上配置一条PPTP内置拨号，自动获取IP地址和网关，启用DMZ功能，设置DMZ目标IP为下挂PC2的IP地址；") {

		}

		operate("2、在PC2上建立FTP服务器，tftp服务器；") {

		}

		operate("3、在PC1上开启TFTP、 FTP客户端访问AP的WAN口IP地址,并进行相应的业务下载或者上传，分别在PC2网卡上，Server上抓包观察；") {

		}

		operate("4、在PC2上访问PC1的WEB服务是否成功；") {

		}

		operate("5、禁用DMZ，重复步骤3，4；") {

		}

		operate("6、反复禁用启用DMZ 3次以上，AP工作是否正常；") {

		}


	end

	def clearup

	end

}
