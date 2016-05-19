#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.15", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT启动完成，检查静态接入配置页面各个按钮，在点击相关按钮后会跳转至相关页面。") {

}

operate("2、设置WAN接入为静态接入方式；") {

}

operate("3、输入IP地址为10.0.0.10，掩码为255.255.255.0，网关为10.0.0.1，DNS为10.0.0.1，点击保存；") {

}



    end

    def clearup

    end

    }
