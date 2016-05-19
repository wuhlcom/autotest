#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_30.1.13", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP正常启动，设置为路由模式；") {

}

operate("2、进入到设备域名界面中，输入zhilu.com，保存；") {

}

operate("3、在LAN侧PC中在浏览器中输入zhilu.com，查看是否会跳转到AP登录界面；") {

}

operate("4、重启路由器，再输入zhulu.com，查看能够跳转到AP登录界面。") {

}



    end

    def clearup

    end

    }
