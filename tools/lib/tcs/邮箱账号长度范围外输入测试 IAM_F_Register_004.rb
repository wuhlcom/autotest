#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Register_004", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、使用邮箱注册用户，邮箱长度33字符；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
