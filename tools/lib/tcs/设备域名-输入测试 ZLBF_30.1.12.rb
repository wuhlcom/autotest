#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_30.1.12", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP正常启动，设置为路由模式；") {

}

operate("2、进入到设备域名界面输入中文：中国人，查看是否能够保存；") {

}

operate("3、在设备域名中输入特殊字符：~!@#$%^&*()，查看是否能够保存；") {

}

operate("4、在设备域名中输入没有.cn/.com/.net查看是否能够保存。") {

}



    end

    def clearup

    end

    }
