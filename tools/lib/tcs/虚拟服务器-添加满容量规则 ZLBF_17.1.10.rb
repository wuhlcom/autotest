#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_17.1.10", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在AP上配置一条PPPoE内置拨号，自动获取IP地址和网关，启用虚拟服务器功能；") {

}

operate("2、添加一条虚拟服务器的规则,协议选择TCP/UDP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {

}

operate("3、继续添加不同的规则，直到满容量为止；") {

}

operate("4、重启AP查看规则有没有丢失。") {

}



    end

    def clearup

    end

    }
