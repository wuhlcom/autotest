#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_14.1.12", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登陆DUT，WAN接入设置为PPPoE方式；") {

}

operate("2、先进入到安全设置的防火墙设置界面，开启防火墙总开关和URL过虑开关，保存；") {

}

operate("3、在URL过滤设置界面选择白名单，添加过滤关键字www.yahoo.com,保存；") {

}

operate("4、PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {

}

operate("5、重启AP后，PC1,PC2是否可以访问www.sina.com.cn，www.yahoo.cn，www.baidu.com等站点；") {

}



    end

    def clearup

    end

    }
