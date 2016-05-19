#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_30.1.11", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP正常启动，设置为路由模式；") {

}

operate("2、进入到设备域名界面中，输入zhilu.com，保存，LAN侧PC输入zhilu.com 是否能够正常登录；") {

}

operate("3、再修改为www.hao123.com， 保存，在LAN侧PC输入www.hao123.com查看是否会跳转到AP登录界面。") {

}



    end

    def clearup

    end

    }
