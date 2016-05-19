#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_21.1.2", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、登录DUT，进入升级页面；") {

}

operate("2、WAN接入设置为PPPoE拨号，正确设置PPPoE拨号参数，保存，LAN PC浏览网页是否正常；") {

}

operate("3、在升级页面中，选择浏览，选择其它格式错误的升级文件（.txt,.jpg,.doc等）,点击升级，查看升级是否成功，PC浏览网页是否正常；") {

}



    end

    def clearup

    end

    }
