#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.5", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps；") {

}

operate("2、添加一条流量控制规则，如IP地址范围输入192.168.1.2，运行模式设置受限最大上行带宽为100kbps；并开启该条规则，保存，查看规则是否可以配置；") {

}

operate("3、在IP地址为192.168.1.2的PC上进行ＦＴＰ下载") {

}

operate("4、重启DUT，查看步骤1、2,3结果是否仍然同上") {

}



    end

    def clearup

    end

    }
