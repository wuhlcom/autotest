#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_034", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、账号A获取手机验证码；") {
}

operate("3、账号B修改密码，使用手机A获取的验证码；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
