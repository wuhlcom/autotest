#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_018", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取应用列表中应用id号；；") {
}

operate("3、删除已绑定设备应用业务进程文件；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
