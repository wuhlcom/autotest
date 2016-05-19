#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_13.1.21", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、分别插入USB设备、TF卡、SD卡，登录web页面，进入多级目录文档共享页面") {

}

operate("2、关闭当前的文件共享功能。关闭后页面是否不显示当前所接设备的文件内容") {

}

operate("3、重启设备后，重新登录页面，查看是否仍为关闭状态") {

}



    end

    def clearup

    end

    }
