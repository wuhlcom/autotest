#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.6", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为10000kbps") {

}

operate("2、假设当前LAN口IP地址为192.168.1.1，对规则1的起始结束地址进行设置，分别为2和254，点击保存") {

}

operate("3、假设当前LAN口IP地址为192.168.1.1，对规则1的起始结束地址进行设置，分别为1和254，点击保存") {

}

operate("4、假设当前LAN口IP地址为192.168.1.1，对规则1的起始结束地址进行设置，分别为2和255，点击保存") {

}

operate("5、假设当前LAN口IP地址为192.168.1.10，对规则1的起始结束地址进行设置，分别为9和11，点击保存") {

}

operate("6、输入其他异常值，例如输入字母，汉字，特殊字符，小数，留空，0等值，点击保存，是否能保存成功") {

}



    end

    def clearup

    end

    }
