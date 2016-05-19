#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_17.1.3", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在“端口”输入全-11，0，65536，是否允许输入") {

}

operate("2、在“端口”输入A~Z,a~z,~!@#$%^等33个特殊字符，中文，空格，为空等，是否允许输入；") {

}

operate("3、输入远程连接的端口，是否允许输入。如果允许输入，需要验证远程连接和虚拟服务器的优先级") {

}



    end

    def clearup

    end

    }
