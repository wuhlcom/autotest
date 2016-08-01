#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_065", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取登录用户uid号；") {
}

operate("3、按设备名称查询，查询字段前后带有空格；") {
}

operate("4、按设备名称查询，查询字段中间带有空格或输入全部空格；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
