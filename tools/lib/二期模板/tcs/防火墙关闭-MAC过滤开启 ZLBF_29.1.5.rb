#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_29.1.5", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP工作在路由方式下，添加两条规则，分别是PC1和PC2的MAC地址；") {

}

operate("2、再进入到防火墙界面，将防火墙总开关关闭，MAC过滤开启，保存，PC1和PC2能否访问外网。") {

}



    end

    def clearup

    end

    }
