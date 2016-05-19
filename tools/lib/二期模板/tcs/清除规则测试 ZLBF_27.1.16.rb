#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_27.1.16", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、进入DUT 带宽控制页面，勾选“开启IP带宽控制”选项框，设置申请带宽为1000kbps") {

}

operate("2、假设当前LAN口地址为192.168.100.1，设置规则1-规则5起始地址段分别为192.168,100.2-192.168.2.6，结束地址段与起始地址段相同。模式都为限制最大带宽为100kbps，启用规则1-5") {

}

operate("3、对每条规则点击“清除”按钮，是否会清除掉页面上的配置") {

}

operate("4、清除后点击保存，刷新页面，确保信息已经清空") {

}



    end

    def clearup

    end

    }
