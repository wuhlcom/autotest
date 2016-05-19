#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_29.1.7", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP工作在路由方式下，添加一条IP过滤规则，源地址包括PC1和PC2的地址其它默认；") {

}

operate("2、再进入到防火墙界面，将防火墙总开关开启，IP过滤关闭，保存，PC1和PC2能否访问外网。") {

}



    end

    def clearup

    end

    }
