#
# description:
# author:liluping
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_5.1.20", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_upload_file_current = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_current/i }
        puts "Current version file:#{@tc_upload_file_current}"

        @tc_upload_file_old = Dir.glob(@ts_upload_directory+"/*").find { |file| file=~/.*_old/i }
        puts "Old version file:#{@tc_upload_file_old}"

        @tc_wait_time       = 3
        @tc_wait_for_login  = 80
        @tc_wait_for_reboot = 120
    end

    def process

        operate("1、点击系统状态的页面，查看页面上显示的版本信息是否与当前测试版本一致") {
            sysversion_text = @browser.span(id: @ts_tag_systemver).parent.text
            sysversion      = sysversion_text.slice(/\s*(V.+?)\s*MAC/i, 1)

            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            pro_version_text = sys_iframe.b(id: @ts_pro_version_id).parent.text
            pro_version      = pro_version_text.slice(/V.+/i)
            assert_equal(sysversion, pro_version, "页面显示的版本信息与当前测试版本不一致")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("2、降级软件版本，然后再到页面上查看显示的版本信息是否正确") {
            @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_op_system).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_update).click
            @option_iframe.file_field(id: @ts_update_filename).set(@tc_upload_file_old)
            sleep @tc_wait_time
            @option_iframe.button(id: @ts_tag_update_btn).click
            sleep @tc_wait_time
            #由于高版本升低版本会弹出升级提示框
            update_confirm = @option_iframe.button(class_name: @ts_tag_reboot_confirm)
            assert(update_confirm.exists?, "当前版本降级到低版本无提示！")
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

            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            pro_version_text = sys_iframe.b(id: @ts_pro_version_id).parent.text
            pro_version      = pro_version_text.slice(/V.+/i)
            assert_equal(sysversion, pro_version, "页面显示的版本信息与当前测试版本不一致")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("3、升版本升级，然后再到页面上查看显示的版本信息是否正确") {
            @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_tag_options).click
            @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
            @option_iframe.link(id: @ts_tag_op_system).wait_until_present(@tc_wait_time)
            @option_iframe.link(id: @ts_tag_op_system).click
            @option_iframe.link(id: @ts_update).click
            @option_iframe.file_field(id: @ts_update_filename).set(@tc_upload_file_current)
            sleep @tc_wait_time
            @option_iframe.button(id: @ts_tag_update_btn).click

            #等待升级完成
            puts "Waitfing for system reboot...."
            sleep(@tc_wait_for_reboot) #由于重启会断开连接所以这里必须使用sleep来等待，而不是用Watir::Wait来等待
            rs = @browser.text_field(:name, @ts_tag_usr).wait_until_present(@tc_wait_for_login)
            assert(rs, "跳转到登录页面失败!")

            #重新登录路由器
            login_no_default_ip(@browser)

            sysversion_text = @browser.span(id: @ts_tag_systemver).parent.text
            sysversion      = sysversion_text.slice(/\s*(V.+?)\s*MAC/i, 1)

            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            pro_version_text = sys_iframe.b(id: @ts_pro_version_id).parent.text
            pro_version      = pro_version_text.slice(/V.+/i)
            assert_equal(sysversion, pro_version, "页面显示的版本信息与当前测试版本不一致")
            if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
                @browser.execute_script(@ts_close_div)
            end
        }

        operate("4、注意页面上有产品版本，和软件版本两处，目前都显示为当前的软件版本，两处要保持一致") {
            @browser.link(id: @ts_sys_status).wait_until_present(@tc_wait_time)
            @browser.link(id: @ts_sys_status).click
            sys_iframe = @browser.iframe(src: @ts_sys_status_src)
            assert(sys_iframe.exists?, "打开系统状态失败！")
            pro_version_text = sys_iframe.b(id: @ts_pro_version_id).parent.text
            pro_version      = pro_version_text.slice(/V.+/i)
            soft_version_text = sys_iframe.b(id: @ts_software_version_id).parent.text
            soft_version      = soft_version_text.slice(/V.+/i)
            assert_equal(soft_version, pro_version, "产品版本和软件版本不一致")

        }


    end

    def clearup

    end

}
