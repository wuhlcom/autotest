#
# description:
# author:wuhongliang
# date:2016-03-12 11:25:32
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_ApMode_1.1.4", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、PC1连接DUT的其他Lan口，动态获取地址，查看是否获取的是上行AP分配的地址；") {

}

operate("2、PC1连接DUT的Wan口，动态获取地址，查看是否能获取上行AP分配的地址；") {

}



    end

    def clearup

    end

    }
