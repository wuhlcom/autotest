#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_047", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录用户uid号；") {
}

operate("3、获取录入设备A的device_id号；") {
}

operate("4、删除设备A；") {
}

operate("5、用户重新添加设备A；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
