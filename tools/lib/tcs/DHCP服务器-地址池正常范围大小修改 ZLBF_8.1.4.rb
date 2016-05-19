#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_8.1.4", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、PC1、PC2、PC3设置自动获取IP地址，查看获取的IP地址，如：192.168.1.100，192.168.1.101，192.168.102；") {

}

operate("2、登陆路由器进入内网设置") {

}

operate("3、更改HDCP地址池范围 如:192.168.1.100~101；") {

}

operate("4、PC1、PC2、PC3 DOS输入ipconfig/release手动释放IP地址，再输入ipconfig/renew重新获取IP地址，查看获取的IP地址是否正确；") {

}



    end

    def clearup

    end

    }
