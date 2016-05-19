#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.16", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、选择静态IP拨号方式；") {

}

operate("2、在IP地址输入0开头地址、或0结尾地址，如：0.0.0.0，10.0.0.0是否允许输入；") {

}

operate("3、IP地址输入组播地址，如239.1.1.1，是否允许输入；") {

}

operate("4、IP地址输入E类地址，如240.1.1.1，是否允许输入；") {

}

operate("5、IP地址输入环回地址，即127开头的地址，如127.0.0.1，是否允许输入；") {

}

operate("6、IP地址输入错误格式地址，如192.168.10，192.168.10.256，a.a.a.a等；") {

}



    end

    def clearup

    end

    }
