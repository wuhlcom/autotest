#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_UserLogin_001", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、用户登录，账号输入错误；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
