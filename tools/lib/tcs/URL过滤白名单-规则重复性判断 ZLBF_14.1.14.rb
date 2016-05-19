#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_14.1.14", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登录到URL过滤设置页面；") {

}

operate("2、设置白名单，添加过滤域名添加www.sina.com,是否能添加成功；") {

}

operate("3、再在白名单界面中添加过滤域名添加www.sina.com,是否能添加成功；") {

}

operate("4、再在白名单界面中添加过滤域名添加http://www.sina.com,是否能添加成功。") {

}



    end

    def clearup

    end

    }
