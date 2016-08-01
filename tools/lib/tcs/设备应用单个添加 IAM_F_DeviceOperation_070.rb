#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_070", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录到IAM服务器；") {
}

operate("2、查询可以授权的应用列表；") {
}

operate("3、对设备授权单个应用；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
