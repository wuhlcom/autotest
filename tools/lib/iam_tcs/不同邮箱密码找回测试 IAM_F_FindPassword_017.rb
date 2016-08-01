#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_017", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、使用不同邮箱进行注册用户，然后进行密码找回测试；如qq邮箱") {
}

operate("3、密码修改；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
