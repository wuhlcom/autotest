#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
    testcase{
      attr = {"id"=>"IAM_F_Application_014", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、ssh登录IAM服务器；") {
}

operate("2、获取知路管理员token值；") {
}

operate("3、创建应用，provider输入带有空格（若是左右存在空格，则保存成功）；") {
}



    end

    def clearup
    operate("1.恢复默认设置"){

    }
    end

    }
