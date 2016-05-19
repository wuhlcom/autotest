#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_28.1.6", "level"=>"P2", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP工作在路由方式下；") {

}

operate("2、添加PC1的MAC地址过滤规则，状态设置为生效，保存配置，再添加PC2的MAC地址的过滤规则，状态设置为失效，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器；") {

}

operate("3、编辑PC2规则设置为生效，保存，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器；") {

}

operate("4、点击下面按钮“使所有条目失效”，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器；") {

}

operate("5、点击下面按钮“使所有条目生效”，查看PC1、PC2能否访问PC3上面的FTP或HTTP服务器。") {

}



    end

    def clearup

    end

    }
