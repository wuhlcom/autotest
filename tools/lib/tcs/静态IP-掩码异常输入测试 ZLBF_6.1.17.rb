#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_6.1.17", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、在子网掩码处输入255.255.255.255，0.0.0.0，是否允许输入；") {

}

operate("2、在子网掩码处输入从左到右不连续为1的地址，如：255.0.255.0,255.128.255.0等是否可以输入；") {

}

operate("3、在子网掩码输入错误格式地址，如256.255.255.255，a.a.a.a等；") {

}



    end

    def clearup

    end

    }
