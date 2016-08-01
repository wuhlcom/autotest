#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_DeviceOperation_020", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取应用A的id号；；") {
}

operate("3、删除应用A进程文件B；") {
}

operate("4、管理员再重新给应用A上传进程文件B；") {
}

operate("5、查询应用A是否存在业务进程文件B；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
