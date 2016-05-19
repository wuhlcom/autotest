#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_34.1.4", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登录AP，进入到定时任务页面") {

}

operate("2、配置一个定时时间，例如配置为当前时间的下一分钟，然后关闭定时任务，点击保存") {

}

operate("3、分别对WAN，LAN，WIFI，防火墙，QOS做相应的配置，记录配置信息。查看时间到后路由器是否重启，重启完成后，查看之前配置的业务是否都正常") {

}



    end

    def clearup

    end

    }
