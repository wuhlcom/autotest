#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_SysManager_109", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值和id号；") {
}

operate("3、修改执行内容；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
