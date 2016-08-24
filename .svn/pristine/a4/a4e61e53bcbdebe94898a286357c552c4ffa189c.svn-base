#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_17.1.5", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在AP上配置一条PPTP内置拨号，自动获取IP地址和网关，启用虚拟服务器功能，新添加一条规则,协议选择TCP/UDP,起始与终止端口设置为5000，服务IP地址设置为PC2地址，保存；") {

}

operate("2、重复步骤1分别添加端口号为80，8080，137，139，1024，10000，65535规则；") {

}

operate("3、重启DUT，查看配置的规则是否存在生效；") {

}

operate("4、复位DUT，查看配置是否完全清空；") {

}



    end

    def clearup

    end

    }
