#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_7.1.33", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、被测AP中插入中国联通4G卡") {

}

operate("2、配置被测AP为通过PPPOE方式上网。PC1上网成功") {

}

operate("3、然后手动切换为3/4G上网，查看切换是否成功，PC1切换后是否能上网，状态页面显示是否正确") {

}

operate("4、手动切换为有线上网，WAN配置为PPPOE，PC1切换后是否能上网，状态页面显示是否正确") {

}



    end

    def clearup

    end

    }
