#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_026", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、用户登录获取用户uid号；") {
}

operate("3、用户添加设备mac；（和云端一致，只测试冒号间隔符）") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
