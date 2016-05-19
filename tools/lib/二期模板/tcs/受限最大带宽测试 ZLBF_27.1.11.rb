#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.11", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {

}

operate("2、假设当前LAN口地址为192.168.100.1，设置规则1地址段为192.168,100.2到192.168,100.2，规则为受限最大带宽，带宽为300kbps；设置规则2地址段为192.168,100.3到192.168,100.3，规则为受限最大带宽，带宽为300kbps；设置规则3地址段为192.168,100.4到192.168,100.4，规则为受限最大带宽，带宽为300kbps；启用规以上规则") {

}

operate("3、AP下接3台电脑，PC1-PC3地址分别为192.168.100.2-4，首先在PC1上使用FTP下载，然后再用PC2 FTP下载，然后再用PC3 FTP下载，统计当前的PC1，PC2和PC3的流量情况") {

}



    end

    def clearup

    end

    }
