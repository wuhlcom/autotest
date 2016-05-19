#
#description:
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_13.1.11", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_storage_usb = "U盘"
        @tc_storage_sd  = "SD卡"
        @tc_cur_path    = "/usbshare"
    end

    def process

        operate("1 打开高级设置") {
            @options_page   = RouterPageObject::OptionsPage.new(@browser)
            @fileshare_page = RouterPageObject::FilesharePage.new(@browser)
        }

        operate("2 打开系统设置开启文件共享") {
            @options_page.open_fileshare_page(@browser.url)
        }

        operate("3 查看共享目录U盘中的文件") {
            rs = @fileshare_page.current_path_element.exists?
            assert(rs, "未打开文件共享目录界面")
            puts "查看#{@tc_storage_usb}中的文件".to_gbk
            #打开U盘
            @fileshare_page.udisk

            #查看U盘中的文件夹
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
            #打开子目录
            @fileshare_page.first_catalog

            #查看U盘中的文件
            file_name = @fileshare_page.second_testfile_element.text
            file_size = @fileshare_page.get_second_testfile_size
            puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

            #返回到根目录
            @fileshare_page.return
            @fileshare_page.return
            rs_back_usb_dir = @fileshare_page.current_path
            assert_equal(@tc_cur_path, rs_back_usb_dir, "返回到U盘根目录失败")
        }

        operate("4 查看SD卡中的文件") {
            puts "查看#{@tc_storage_sd}中的文件".to_gbk
            @fileshare_page.sdcard

            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk

            @fileshare_page.first_catalog
            file_name = @fileshare_page.second_testfile_element.text
            file_size = @fileshare_page.get_second_testfile_size
            puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

            #返回到根目录
            @fileshare_page.return
            @fileshare_page.return
            rs_back_usb_dir = @fileshare_page.current_path
            assert_equal(@tc_cur_path, rs_back_usb_dir, "返回到U盘根目录失败")
        }

        operate("5 重启路由器") {
            @options_page.reboot
            rs = @options_page.login_with_exists(@browser.url)
            assert(rs, "重启后未跳转到登录界面！")
        }

        operate("6 重启路由器后,重新登录路由器，打开高级设置") {
            rs_login = login_no_default_ip(@browser) #重新登录
            assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("7 重启路由器后，打开系统设置查看文件共享") {
            @options_page.open_fileshare_page(@browser.url)
        }

        operate("8 重启路由器后，查看共享目录U盘中的文件") {
            rs = @fileshare_page.current_path_element.exists?
            assert(rs, "未打开文件共享目录界面")
            puts "查看#{@tc_storage_usb}中的文件".to_gbk
            #打开U盘
            @fileshare_page.udisk

            #查看U盘中的文件夹
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
            #打开子目录
            @fileshare_page.first_catalog

            #查看U盘中的文件
            file_name = @fileshare_page.second_testfile_element.text
            file_size = @fileshare_page.get_second_testfile_size
            puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

            #返回到根目录
            @fileshare_page.return
            @fileshare_page.return
            rs_back_usb_dir = @fileshare_page.current_path
            assert_equal(@tc_cur_path, rs_back_usb_dir, "返回到U盘根目录失败")
        }

        operate("9 重启路由器后，查看SD卡中的文件") {
            puts "查看#{@tc_storage_sd}中的文件".to_gbk
            @fileshare_page.sdcard

            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk

            @fileshare_page.first_catalog
            file_name = @fileshare_page.second_testfile_element.text
            file_size = @fileshare_page.get_second_testfile_size
            puts "测试文件名：#{file_name}------------文件大小：#{file_size}".to_gbk

            #返回到根目录
            @fileshare_page.return
            @fileshare_page.return
            rs_back_usb_dir = @fileshare_page.current_path
            assert_equal(@tc_cur_path, rs_back_usb_dir, "返回到U盘根目录失败")
        }

    end

    def clearup

        operate("恢复环境，关闭文件共享") {
            fileshare_page = RouterPageObject::FilesharePage.new(@browser)
            fileshare_page.close_fileshare(@browser.url)
        }
    end

}
