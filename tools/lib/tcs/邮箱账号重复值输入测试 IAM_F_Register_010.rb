#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Register_010", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、使用邮箱注册用户；") {
}

operate("3、再次注册一个用户，邮箱还使用步骤2的邮箱") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
