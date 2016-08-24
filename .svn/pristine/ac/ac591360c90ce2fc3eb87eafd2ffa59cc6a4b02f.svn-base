#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.8", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {

}

operate("2、假设当前LAN口IP地址为192.168.1.1，设置规则1的地址段为192.168.1.2到192.168.1.10，设置最大受限带宽为100kbps，并保存本条规则") {

}

operate("3、下接电脑的IP地址为192.168.1.2，进行FTP下载，验证流量是否受限为100kbps") {

}

operate("4、修改LAN口IP地址为192.168.2.1，修改完成后，查看规则1的地址段是否自动变更为192.168.2.2到192.168.2.10，其他数据不变") {

}

operate("5、下接电脑的IP地址为192.168.2.2，进行FTP下载，验证流量是否受限为100kbps") {

}



    end

    def clearup

    end

    }
