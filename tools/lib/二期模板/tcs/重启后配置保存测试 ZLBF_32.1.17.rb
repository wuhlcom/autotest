#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_32.1.17", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP1，AP2都连接到测试网，AP1和AP2配置正确，形成GRE隧道，且链路通讯正常") {

}

operate("2、AP1和AP2都断电重启，待重启成功后，查看GRE配置是否保留。GRE之间的链路通讯是否仍然正常") {

}



    end

    def clearup

    end

    }
