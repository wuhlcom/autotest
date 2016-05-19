#
# description:
# author:wuhongliang
# date:2015-08-26 11:47:04
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_30.1.1", "level"=>"P1", "auto"=>"n"}
    def prepare

    end

    def process

      operate("1、DUT启动，设置WAN接入类型为DHCP，（假设获取到的地址为10.10.0.100）；") {

}

operate("2、启用远程访问管理功能，访问权限设置为任何人，端口为默认值，查看页面显示的远程管理地址信息是否准确；") {

}

operate("3、PC2通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面（注意登录认证对话框等显示字符的合法/正确性，如不能显示异常字符图片或不符合当前客户的字符图片）；") {

}

operate("4、测试网上另一台主机PC3通过WAN口IP地址+设置的远程访问端口号是否能访问到DUT的WEB管理页面；") {

}

operate("5、PC2通过WAN口IP地址+非设置的远程访问端口号是否能访问到DUT的WEB管理页面。") {

}



    end

    def clearup

    end

    }
