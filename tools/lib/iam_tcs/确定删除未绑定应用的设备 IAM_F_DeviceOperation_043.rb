#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_043", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录用户的uid号；") {
}

operate("3、获取录入设备device_id号；") {
}

operate("4、删除设备；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
