#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.14", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登录DUT设置页面，在BAS开启抓包；") {

}

operate("2、手动设置静态IP方式接入，如输入IP地址：192.168.25.111，子网掩码：255.255.255.0，网关：192.168.25.9，设置DNS为外网有效的DNS地址，如：202.96.134.133，保存；运行状态及设置页面显示的DNS信息显示是否正常；") {

}

operate("3、LAN PC上在DOS下输入:ipconfig/flushdns，清除PC的DNS缓存,执行ping www.sohu.com，在BAS抓包确认，DUT是否以202.96.134.133发送出DNS请求；") {

}

operate("4、在步骤2中更改DNS为：202.96.134.134，重复步骤3，查看测试结果；") {

}

operate("5、反复更改DNS三次以上，查看测试结果。") {

}



    end

    def clearup

    end

    }
