#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_28.1.5", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP工作在路由方式下；") {

}

operate("2、添加基于的MAC地址过滤规则，32条规则都添加完（运行设置的规则总数目），其中有两条是PC1、PC2的MAC地址，保存配置；") {

}

operate("3、重启AP，查看设备有无丢配置等异常现象；") {

}

operate("4、PC1和PC2能否访问PC3的FTP或访问外网是否成功；") {

}

operate("5、将配置文件保存为文件1，进行复位操作，再将配置文件1导入设备，检查导入是否正确，PC1和PC2能否访问PC3的FTP或访问外网是否成功。") {

}



    end

    def clearup

    end

    }
