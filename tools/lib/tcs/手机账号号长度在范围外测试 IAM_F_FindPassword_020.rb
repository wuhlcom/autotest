#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_FindPassword_020", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、手机号码输入大于11位或者小于11位；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
