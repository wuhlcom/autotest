#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_17.1.4", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、恢复DUT默认配置，设置接入类型为PPTP；") {

}

operate("2、添加一条虚拟服务器规则，保存配置，验证规则是否生效；") {

}

operate("3、修改网关地址为与默认地址同网段的其他地址，验证步骤2中添加的规则是否生效；") {

}

operate("4、修改网关地址为与默认地址不同网段的地址，规则中服务IP地址是否能修改成相应网段的IP地址，若修改成功，验证规则是否生效；") {

}

operate("5、在步骤4，修改成功的基础上，再将网关地址修改成默认网段的IP地址，验证规则是否生效；") {

}



    end

    def clearup

    end

    }
