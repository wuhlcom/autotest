#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.45", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、BAS开启抓包；") {

}

operate("2、设置DUT的WAN拨号方式为PPTP，DNS为自动获取方式，BAS认证强制设置为MS-CHAPv1，设置PPTP服务器的IP地址为192.168.25.9，网关地址为192.168.25.9,IP地址设置与服务器同一网段，例如：192.168.25.100，mask填写为255.255.255.0，并填写正确的拨号用户名和密码，提交并保存设置；") {

}

operate("3、抓包确认在PPP LCP过程中，BAS与DUT协商是否采用MS-CHAPv1认证(协议码：0xc223,Algorithm:0x80)，拨号是否成功，查看WAN连接，IP，路由，DNS等信息统计页面显示信息是否正确；") {

}

operate("4、LAN PC与STA PC上网业务是否正常；") {

}

operate("5、设置错误的用户名或密码，查看WAN连接，路由，DNS等信息统计页面，是否可以上网。") {

}



    end

    def clearup

    end

    }
