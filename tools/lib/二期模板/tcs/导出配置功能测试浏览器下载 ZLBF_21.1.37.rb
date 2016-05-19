#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_21.1.37", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、配置WAN连接为PPPoE方式，输入正确用户名与密码，保存，拨号是否成功，PC上网业务是否正常；") {

}

operate("2、修改LAN口IP地址，修改地址池范围，修改无线SSID，修改无线安全，修改无线高级参数，添加端口转发规则、端口触发规则、添加URL过滤规则、IP与端口过滤规则、开启UPNP功能、开启DMZ功能、开启DDNS功能、修改登录密码等，") {

}

operate("3、点击备份，查看备份文件操作是否成功；") {

}



    end

    def clearup

    end

    }
