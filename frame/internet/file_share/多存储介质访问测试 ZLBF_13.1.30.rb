#
#description:
# 无法判断一个正在进行时，另一个下载也在进行
#author:wuhongliang
#date:2015-06-30 14:12:41
#modify:
#
testcase {
    attr = {"id" => "ZLBF_13.1.30", "level" => "P1", "auto" => "n"}

    def prepare

        @ts_download_directory.gsub!("\\", "/")
        @tc_download_time = 200
        @tc_storage_usb   = "U盘"
        @tc_storage_sd    = "SD卡"
        @tc_share_dir     = "一级目录"
        @tc_usb_dl_name   = "二级Pycharm_TEST.exe"
        @tc_sd_dl_name    = "二级RubyMine_TEST.exe"
    end

    def process

        operate("1 打开高级设置") {
            @options_page   = RouterPageObject::OptionsPage.new(@browser)
            @fileshare_page = RouterPageObject::FilesharePage.new(@browser)

            if File.exists? @ts_download_directory
                puts("下载文件保存路径：#{@ts_download_directory}".to_gbk)
                files = Dir.glob("#{@ts_download_directory}/**/*")
                unless files.empty?
                    puts "=="*40
                    puts "删除已存在的文件夹与文件:".to_gbk
                    #不删除路由器的配置文件
                    files.delete_if { |file|
                        file=~/config/i
                    }
                    print files.join("\n").to_gbk
                    print "\n"
                    puts "=="*40
                    FileUtils.rm_rf(files)
                end
            end
        }

        operate("2 打开系统设置开启文件共享") {
            @options_page.open_fileshare_page(@browser.url)
        }

        operate("3 查看U盘中的文件是否存在") {
            rs = @fileshare_page.current_path_element.exists?
            assert(rs, "未打开文件共享目录界面")

            usb_dir = @fileshare_page.udisk_element
            assert(usb_dir.exists?, "未显示U盘")
            puts "查看#{@tc_storage_usb}中的内容".to_gbk
            @fileshare_page.udisk

            #查看U盘中的文件夹
            rs_sub_dir = @fileshare_page.first_catalog_element.exists?
            assert(rs_sub_dir, "找不到U盘中的文件夹")
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
            @fileshare_page.first_catalog #打开一级目录

            #查看U盘中的要下载的文件是否存在
            rs_file = @fileshare_page.second_pycharm_testfile_element.exists?
            assert(rs_file, "未找到要下载的测试文件")
            @tc_usb_download_file_name = @fileshare_page.second_pycharm_testfile_element.text
            @tc_usb_download_file_size = @fileshare_page.get_second_py_size
            puts "测试文件名：#{@tc_usb_download_file_name}------------文件大小：#{@tc_usb_download_file_size}".to_gbk
            @tc_usb_download_file_size=~/^(\d+\.*\d+)/
            @tc_usb_file_size=Regexp.last_match(1)
        }

        operate("4 打开第二个浏览器窗口用于进行SD卡下载测试") {
            @browser.execute_script("window.open('http://#{@ts_default_ip}')")
            #得个@browser对象下各个窗口对象的句柄对象
            @tc_handles = @browser.driver.window_handles
            #通过句柄来切换不同的windows窗口
            @browser.driver.switch_to.window(@tc_handles[1])
            # rs_login = login_no_default_ip(@browser) #重新登录
            # assert(rs_login[:flag], "登录失败：#{rs_login[:message]}")
        }

        operate("5 在第二个浏览器窗口查看SD卡中的文件是否存在") {
            @options_page.open_fileshare_page(@browser.url)
            rs = @fileshare_page.current_path_element.exists?
            assert(rs, "第二个窗口文件共享未开启")

            sd_dir = @fileshare_page.sdcard_element
            assert(sd_dir.exists?, "第二个窗口未显示SD卡")
            puts "查看#{@tc_storage_sd}中的文件".to_gbk

            #打开SD卡目录
            @fileshare_page.sdcard
            rs_sub_dir = @fileshare_page.first_catalog_element.exists?
            assert(rs_sub_dir, "第二个窗口找不到SD卡中的文件夹")
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk
            #打开SD卡一级目录
            @fileshare_page.first_catalog

            rs_file = @fileshare_page.second_ruby_testfile_element.exists?
            assert(rs_file, "第二个窗口未找到SD卡中要下载的文件")
            @tc_sd_download_file_name = @fileshare_page.second_ruby_testfile_element.text
            @tc_sd_download_file_size = @fileshare_page.get_second_ruby_size
            puts "测试文件名：#{@tc_sd_download_file_name}------------文件大小：#{@tc_sd_download_file_size}".to_gbk
            @tc_sd_download_file_size=~/^(\d+\.*\d+)/
            @tc_sd_file_size=Regexp.last_match(1)
        }

        operate("6 U盘在下载的同时SD卡也在下载") {
            #下载SD卡的文件
            puts "下载SD卡的文件".to_gbk
            @fileshare_page.second_ruby_testfile
            #下载U盘中的文件
            puts "下载U盘中的文件".to_gbk
            #通过句柄来切换不同的windows窗口
            @browser.driver.switch_to.window(@tc_handles[0])
            @fileshare_page.second_pycharm_testfile
            puts "Waiting for Download Files....."
            sleep @tc_download_time
        }

        operate("7 查看文件是否下载成功") {
            if File.exist?(@ts_download_directory)
                files = Dir.glob("#{@ts_download_directory}/**/*")
                if files.empty?
                    assert(false, "文件下载失败，未到下载的文件")
                else
                    puts "=="*50
                    puts "已经下载的文件:".to_gbk
                    #配置文件排除在外
                    files.delete_if { |file|
                        file=~/config/i
                    }
                    print files.join("\n").to_gbk
                    print "\n"
                    puts "=="*50
                    dl_usb_file_size = 0
                    dl_sd_file_size  = 0
                    files.each do |file|
                        next if file !~ /#{@tc_usb_dl_name}|#{@tc_sd_dl_name}/
                        if file=~/#{@tc_usb_dl_name}/
                            usb_file_size    = File.size(file)
                            #计算文件大小
                            dl_usb_file_size = usb_file_size.to_f/1024.00/1024.00
                            dl_usb_file_size = dl_usb_file_size.roundf(2)
                            puts "读取从U盘中下载的文件#{@tc_usb_dl_name}，大小为#{dl_usb_file_size}".to_gbk
                        elsif file=~/#{@tc_sd_dl_name}/
                            sd_file_size    = File.size(file)
                            dl_sd_file_size = sd_file_size.to_f/1024/1024
                            dl_sd_file_size = dl_sd_file_size.roundf(2)
                            puts "读取从SD卡中下载的文件#{@tc_sd_dl_name}，大小为#{dl_sd_file_size}".to_gbk
                        end
                    end
                    #浮点数使用字符串的形式来比较
                    flag_usb     = (@tc_usb_file_size == dl_usb_file_size.to_s) && (dl_usb_file_size > 0)
                    flag_sd      = (@tc_sd_file_size == dl_sd_file_size.to_s) && (dl_sd_file_size > 0)
                    usb_download = files.any? { |file| file=~/#{@tc_usb_dl_name}/ }
                    sd_download  = files.any? { |file| file=~/#{@tc_sd_dl_name}/ }
                    assert(usb_download, "U盘中文件未下载")
                    assert(flag_usb, "U盘中文件下载异常")
                    assert(sd_download, "SD卡中文件未下载")
                    assert(flag_sd, "SD卡中文件下载异常")
                end
            else
                assert(false, "下载文件保存目录不存在")
            end
        }
    end

    def clearup

        operate("恢复环境，关闭文件共享") {
            tc_handles = @browser.driver.window_handles
            @browser.driver.switch_to.window(tc_handles[0])
            fileshare_page = RouterPageObject::FilesharePage.new(@browser)
            fileshare_page.close_fileshare(@browser.url)
        }
    end

}
