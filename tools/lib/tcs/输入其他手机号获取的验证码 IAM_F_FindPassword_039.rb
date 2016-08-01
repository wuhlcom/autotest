#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_039", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、手机号A获取手机验证码；") {
}

operate("3、手机号B修改密码，验证码输入手机号A的验证码；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
