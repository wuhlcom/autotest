#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:18
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_OAuth_023", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录到IAM服务器；") {
}

operate("2、获取接口认证code值；") {
}

operate("3、code有效期内获取认证access_token值；") {
}

operate("4、code超时后获取认证access_token值；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
