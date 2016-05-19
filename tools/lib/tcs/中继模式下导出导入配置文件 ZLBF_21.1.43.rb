#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_21.1.43", "level"=>"P4", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、修改当前AP为中继模式，且中继成功，导出配置文件") {

}

operate("2、修改AP为桥模式，且桥接成功。然后导入步骤1中的配置文件，导入成功后，查看AP的连接模式") {

}

operate("3、修改AP为桥模式，且桥接成功，然后导出配置文件") {

}

operate("4、修改AP为中继模式，且中继成功，然后导入步骤3中的配置文件，导入成功后，查看AP的连接模式") {

}



    end

    def clearup

    end

    }
