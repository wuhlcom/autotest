#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_028", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、用户登录获取用户uid号；") {
}

operate("3、用户添加的格式异常的设备MAC；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
