#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_15.1.18", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT的接入类型选择为DHCP，保存配置；") {

}

operate("2、进入到安全设置的防火墙设置界面，开启防火墙总开关和IP过虑开关，在IP过虑界面添加规则，直到不能添加为止，查看是否添加成功，添加数目与最大允许数目是否一致；") {

}

operate("3、使用iptables-nvx-L命令查看所有规则添加与服务限制规则表显示规则数目、端口等是否正确；") {

}

operate("4、使用数据包模拟器模拟匹配第一条，最后一条，及中间若干条规则数据包，由LAN到WAN发送数据包，在PC2上抓包，是否能收到PC1发出的数据包。") {

}

operate("5、DUT重启后，所有添加规则是否都存在无丢失。") {

}

operate("6、非顺序删除添加的所有规则，查看删除是否成功，iptables-nvx-L命令查看是否删除成功。") {

}

operate("7、DUT重启后，添加规则是否还存在。") {

}



    end

    def clearup

    end

    }
