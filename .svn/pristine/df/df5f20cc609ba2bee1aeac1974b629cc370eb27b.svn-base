#
# description:
# 用例应 验证格式和及内容由0-9，A-F就可以，无需验证MAC地址类别
# author:wuhongliang
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_28.1.7", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_mac_error = "MAC地址格式错误"
        @tc_mac_desc  = "test"
    end

    def process

        operate("1、AP工作在路由方式下，输入MAC地址包含~!@#$%^&*()_+{}|:\"<>?等键盘上33个特殊字符,查看是否允许输入保存；") {
            @status_page = RouterPageObject::SystatusPage.new(@browser)
            @status_page.open_systatus_page(@browser.url)
            @tc_lanmac = @status_page.get_lan_mac
            puts "LAN MAC #{@tc_lanmac}"
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end

            @options_page = RouterPageObject::OptionsPage.new(@browser)
            @options_page.open_security_setting(@browser.url) #打开安全界面
            @options_page.firewall_click
            @options_page.open_switch("on", "off", "on", "off")
            @options_page.macfilter_click
            @options_page.mac_add_item_element.click #新增条目

            #添加有线客户端过滤条件
            tc_mac1 = ""
            puts "MAC未输入".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #添加有线客户端过滤条件
            tc_mac1 = "$@#"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #添加有线客户端过滤条件
            tc_mac2 = "00:@@:22:33:44:55"
            puts "添加MAC #{tc_mac2}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac2, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #添加有线客户端过滤条件,特殊符号
            tc_mac3 = "00:@@:22:33:44:55"
            puts "添加MAC #{tc_mac3}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac3, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #添加有线客户端过滤条件,字母
            tc_mac4 = "00:11:GG:33:44:55"
            puts "添加MAC #{tc_mac4}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac4, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #添加有线客户端过滤条件,空格
            tc_mac5 = "00:11:22:  :44:55"
            puts "添加MAC #{tc_mac5}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac5, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
        }

        operate("2、输入MAC地址：00:00:00:00:00:00，查看是否允许输入保存；") {
            #添加有线客户端过滤条件,空格
            tc_mac1 = "00:00:00:00:00:00"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
        }

        operate("3、输入MAC地址：FF:FF:FF:FF:FF:FF，查看是否允许输入保存；") {
            #添加有线客户端过滤条件,空格
            tc_mac1 = "FF:FF:FF:FF:FF:FF"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
        }

        # operate("4、输入MAC地址：0x:00:00:00:00:01,x=1,3,5,7,9,a,c,f，查看是否允许输入保存；") {		}
        # operate("5、输入MAC地址以01:00:5e开头的MAC地址，如：01:00:5e:00:00:01,查看是否允许输入保存；") {
        # }

        operate("6、输入MAC地址：90:AB:CD:EF:ab:cf，查看是否允许输入保存；") {
            #添加有线客户端过滤条件,空格
            tc_mac1 = "90:AB:CD:EF:ab:cf"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_empty(error_tip.text, "设置正确MAC却提示失败")
        }

        # operate("7、输入MAC地址与AP的LAN MAC或WLAN接口地址一致的地址，查看是否允许输入保存；") {
        #添加有线客户端过滤条件,LAN MAC
        #用例预期结果不明不实现
        # puts "添加LAN MAC #{@tc_lanmac}为过滤条件".encode("GBK")
        # @advance_iframe.span(id: @ts_tag_additem).click
        # @advance_iframe.text_field(id: @ts_tag_fwmac_mac).set(@tc_lanmac)
        # sleep @tc_wait_time
        # @advance_iframe.text_field(id: @ts_tag_fwmac_desc).set(@tc_mac_desc)
        # select_list = @advance_iframe.select_list(id: @ts_tag_fw_select)
        # #设置为生效
        # unless select_list.selected?(@ts_tag_filter_use)
        # 		select_list.select(/#{@ts_tag_filter_use}/)
        # end
        #
        # #保存mac过滤条件
        # @advance_iframe.button(id: @ts_tag_save_filter).click
        # sleep @tc_filter_time
        # error_tip = @advance_iframe.p(id: @ts_tag_band_err)
        # assert(error_tip.exists?, "未提示MAC地址格式错误")
        # puts "ERROR TIP:#{error_tip.text}".encode("GBK")
        # assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
        # }

        # operate("8、输入MAC地址：00-AB-CD-EF-ab-cf格式地址，查看是否允许输入保存；") {
        # 		#不支持，这种输入，用例应该限定要支持还是不要支持
        # }

        # operate("9、输入MAC地址：00ABCDEFabcf格式地址，查看是否允许输入保存；") {
        # 		#不支持，这种输入，用例应该限定要支持还是不要支持
        # }

        operate("10、输入MAC地址：00-AB-CD-EF-ab-cg,00-AB-CD-EF-ab-cG,00-AB-CD-EF-ab-cff,00-AB-CD-EF-ab-c,查看是否允许输入保存；") {
            #xx:yy:xx:yy:xx
            tc_mac1 = "02:11:22:33:44"
            puts "添加MAC #{tc_mac1}为过滤条件".encode("GBK")
            @options_page.mac_add_item_element.click #新增条目
            @options_page.mac_filter_input(tc_mac1, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #xx:yy:xx:yy:xx:yy:zz
            tc_mac2 = "02:11:22:33:44:55:66"
            puts "添加MAC #{tc_mac2}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac2, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #x:yy:xx:yy:xx:yy:
            tc_mac3 = "0:11:22:33:44:55"
            puts "添加MAC #{tc_mac3}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac3, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")

            #xx:yyx:xx:yy:xx:yy
            tc_mac4 = "00:111:22:33:44:55"
            puts "添加MAC #{tc_mac4}为过滤条件".encode("GBK")
            @options_page.mac_filter_input(tc_mac4, @tc_mac_desc) #输入，状态默认为生效
            @options_page.mac_save #保存mac过滤条件
            sleep 1
            error_tip =@options_page.mac_filter_err_msg_element
            assert(error_tip.exists?, "未提示MAC地址格式错误")
            puts "ERROR TIP:#{error_tip.text}".encode("GBK")
            assert_equal(@tc_mac_error, error_tip.text, "提示内容错误")
        }


    end

    def clearup

        operate("1、恢复防火墙默认设置：关闭总开关并删除所有规则") {
            options_page = RouterPageObject::OptionsPage.new(@browser)
            options_page.macfilter_close_sw_del_all(@browser.url)
        }

    end

}
