#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.9", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {

}

operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为保障最小带宽，带宽为700kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为保障最小带宽，带宽为300kbps，启用规则1和规则2") {

}

operate("3、AP下接3台电脑，PC1-PC3地址分别为192.168.100.2-4，首先在PC3上进行FTP下载，然后再用PC1进行FTP下载，统计当前的PC1和PC3流量情况") {

}

operate("4、步骤3基础上，再在PC2上进行FTP下载，统计当前PC1，PC2，PC3的流量情况") {

}



    end

    def clearup

    end

    }
