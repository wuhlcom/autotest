#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:03
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.1", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT管理页面，去勾选“开启IP带宽控制”选项框，查看自动带宽，上下行速率，流量控制规则页面是否可以设置；") {

}

operate("2、重启DUT，查看步骤1结果是否生效。") {

}



    end

    def clearup

    end

    }
