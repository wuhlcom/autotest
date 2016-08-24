#
# description:
#下载过程中关闭共享，关闭共享后，还能操作路由器，并查看到共享界面是关闭
#统一平台版本在下载过程中无法关闭共享，并有提示："设备正在使用中,关闭失败" 2016/04/06
# author:wuhongliang
# date:2015-11-05 14:00:18
# modify:
#
testcase {
    attr = {"id" => "ZLBF_13.1.23", "level" => "P4", "auto" => "n"}

    def prepare
        @ts_download_directory.gsub!("\\", "\/")
        @tc_download_time    = 5
        @tc_wait_time        = 3
        @tc_close_share_time = 5
        @tc_download_file    = "二级Pycharm_TEST.exe"
        @tc_download_path    = @ts_download_directory+"/#{@tc_download_file}"
        @tc_hint_msg         = "设备正在使用中,关闭失败"
    end

    def process

        operate("1、分别插入USB设备、TF卡、SD卡，登录web页面，进入到文档共享页面，") {
            @options_page   = RouterPageObject::OptionsPage.new(@browser)
            @fileshare_page = RouterPageObject::FilesharePage.new(@browser)
        }

        operate("2、开启当前的文件共享功能。开启后页面是否显示当前所接设备的文件内容") {
            @options_page.open_fileshare_page(@browser.url)
            rs = @fileshare_page.current_path?
            assert(rs, "文件共享打开失败")
            udisk_status = @fileshare_page.udisk?
            assert(udisk_status, "文件共享未显示U盘")

            #查看U盘中的文件夹
            @fileshare_page.udisk #打开U盘目录
            dir_name = @fileshare_page.first_catalog_element.text
            dir_size = @fileshare_page.get_first_catalog_size
            puts "文件夹名：#{dir_name}----文件大小:#{dir_size}".to_gbk

            #打开子目录
            @fileshare_page.first_catalog
        }

        operate("3、点击其中的文件进行下载，下载过程中在页面上把文件共享功能关闭，查看AP是否异常") {
            #下载U盘中的子目录下的文件
            #判断当前下载目录是否有配置文件，如果有则将其重命名
            dl_file_path = Dir.glob(@ts_download_directory+"/*").find { |file|
                file=~/#{@tc_download_file}$/
            }
            unless dl_file_path.nil?
                puts "删除下载目录中的旧文件:#{dl_file_path}".encode("GBK")
                File.delete(dl_file_path)
            end

            file_state = File.exists?(@tc_download_path)
            refute(file_state, "下载目录中旧文件:#{@tc_download_file}未删除")

            dl_file_name = @fileshare_page.second_pycharm_testfile_element.text
            dl_file_size = @fileshare_page.get_second_py_size
            puts "要下载的文件名：#{dl_file_name}------------文件大小：#{dl_file_size}".to_gbk
            thr = Thread.new do
                #点击文件开始下载
                @fileshare_page.second_pycharm_testfile #下载文件
                sleep @tc_download_time
            end
            sleep @tc_wait_time
            #下载过程中，关闭共享
            puts "下载过程中关闭共享".encode("GBK")
            @fileshare_page.close_share
            sleep 2
            p "查看是否正常关闭".to_gbk
            @options_page.open_options_page(@browser.url)
            @options_page.select_fileshare #进入文件共享页面
            sleep 2
            rs = @fileshare_page.current_path?
            refute(rs, "文件共享打开失败")
        }


    end

    def clearup
        operate("1 恢复环境，关闭文件共享") {
            fileshare_page = RouterPageObject::FilesharePage.new(@browser)
            fileshare_page.close_fileshare(@browser.url)
        }
    end

}
