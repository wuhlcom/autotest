#
# description:
# author:liluping
# date:2015-11-05 14:00:19
# modify:
#
testcase {
    attr = {"id" => "ZLBF_21.1.11", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
        puts "Current version file:#{@tc_upload_file_current}"

        @tc_upload_file_same = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_same/i }
        puts "Same version file:#{@tc_upload_file_same}"

        @tc_wait_time       = 3
        @tc_wait_for_login  = 80
        @tc_wait_for_reboot = 180
    end

    def process

        operate("1、登录到DUT管理页面，进行到升级页面；") {
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            assert(@option_iframe.exists?, "打开高级设置界面失败")
            @option_iframe.link(id: @ts_tag_op_system).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_update).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_update).click #进入升级页面
        }

        operate("2、选择一相同版本号的软件，点击升级，查看升级是否成功") {
            @option_iframe.file_field(id: @ts_update_filename).set(@tc_upload_file_same)
            sleep @tc_wait_time
            @option_iframe.button(id: @ts_tag_update_btn).click
            #由于同版本升级会弹出提示框
            update_confirm = @option_iframe.div(class_name: @ts_upload, text: @ts_upload_same_text)
            update_confirm.wait_until_present(@tc_wait_time)
            assert(update_confirm.exists?, "当前同版本升级无提示！")
            @option_iframe.button(class_name: @ts_tag_reboot_confirm).click
            #等待升级完成
            puts "Waitfing for system reboot...."
            sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
            rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
            assert(rs, "跳转到登录页面失败!")
            #重新登录路由器
            login_no_default_ip(@browser)
            sysversion_text = @browser.span(id: @ts_tag_systemver).parent.text
            sysversion      = sysversion_text.slice(/\s*(V.+?)\s*MAC/i, 1)
            actual_version  = @tc_upload_file_same.slice(/V\d+R\d+C\d+/i) #MT7620A_16X128_SZCX_ZL-R707_V100R003C028SPC001_r6473_old
            assert_equal(sysversion, actual_version, "升级失败！")
        }


    end

    def clearup

    end

}
