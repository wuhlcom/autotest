#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_057", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录用户uid号；") {
}

operate("3、查询设备名称为知路科技公司的设备信息；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
