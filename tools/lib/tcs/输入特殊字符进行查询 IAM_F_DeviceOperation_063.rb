#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_063", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录用户uid号；") {
}

operate("3、按设备名称查询，输入特殊字符；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
