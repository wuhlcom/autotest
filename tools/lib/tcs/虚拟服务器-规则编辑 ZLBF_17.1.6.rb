#
# description:
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_17.1.6", "level"=>"P3", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、AP的接入类型选择为DHCP，保存配置；") {

}

operate("2、添加一条虚拟服务器规则,协议选择TCP,起始端口设置为10000，终止端口设置为10000，服务IP地址设置为PC2地址，保存；") {

}

operate("3、在PC1上打开IPTEST工具，网络模式选择“客户端模式”，网络类型选择“TCP”，远程端口号设置为10000，远程IP地址设置为“AP WAN口IP地址”，点击“开始连接”，分别在PC1，PC2网卡上抓包观察；") {

}

operate("4、选择步骤2中添加的规则，更改协议为UDP,起始端口设置为20000，终止端口设置为20000，服务IP地址设置为PC2地址，是否能对已选择的规则进行修改，保存；") {

}

operate("5、在PC1上打开IPTEST工具，网络模式选择“客户端模式”，网络类型选择“UDP”，远程端口号设置为20000，远程IP地址设置为“AP WAN口IP地址”，点击“开始连接”,输入要发送的内容，点击“发送”，分别在PC1，PC2网卡上抓包观察；") {

}

operate("") {

}



    end

    def clearup

    end

    }
