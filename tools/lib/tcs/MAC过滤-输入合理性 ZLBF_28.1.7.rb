#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_28.1.7", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP工作在路由方式下，输入MAC地址包含~!@#$%^&*()_+{}|:"<>?等键盘上33个特殊字符,查看是否允许输入保存；") {

}

operate("2、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {

}

operate("3、输入MAC地址：FF:FF:FF:FF:FF:FF，查看是否允许输入保存；") {

}

operate("4、输入MAC地址：0x:00:00:00:00:01,x=1,3,5,7,9,a,c,f，查看是否允许输入保存；") {

}

operate("5、输入MAC地址以01:00:5e开头的MAC地址，如：01:00:5e:00:00:01,查看是否允许输入保存；") {

}

operate("6、输入MAC地址：90:AB:CD:EF:ab:cf，查看是否允许输入保存；") {

}

operate("7、输入MAC地址与AP的LAN MAC或WLAN接口地址一致的地址，查看是否允许输入保存；") {

}

operate("8、输入MAC地址：00-AB-CD-EF-ab-cf格式地址，查看是否允许输入保存；") {

}

operate("9、输入MAC地址：00ABCDEFabcf格式地址，查看是否允许输入保存；") {

}

operate("10、输入MAC地址：00-AB-CD-EF-ab-cg,00-AB-CD-EF-ab-cG,00-AB-CD-EF-ab-cff,00-AB-CD-EF-ab-c,查看是否允许输入保存；") {

}



    end

    def clearup

    end

    }
