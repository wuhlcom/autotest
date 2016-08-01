#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_ApplicationCenter_011", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录服务器；") {
}

operate("2、获取应用的ID号；") {
}

operate("3、获取登录用户的token值和id号；") {
}

operate("4、用户绑定应用；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
