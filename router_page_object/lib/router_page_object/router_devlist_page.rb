#encoding:utf-8
#
# 已连接设备列表
# author:liluping
# date:2016-04-18
# modify:
#
file_path1 =File.expand_path('../router_main_page', __FILE__)
require file_path1

module RouterPageObject

    module Devlist_Page
        include PageObject
        in_iframe(:src => @@ts_tag_devices_iframe_src) do |frame|
            table(:devlist_data, id: @@ts_tag_devlist_table, frame: frame)
            link(:devlist_refresh, id: @@ts_tag_devlist_refresh) #刷新
            span(:dev_list, class_name: @@ts_tag_devlist)
        end
    end

    class DevlistPage < MainPage
        include Devlist_Page

        #获取已连接设备数
        def get_dev_size
            dev_list_element.parent.em_element.text.to_i
        end

        #打开已接连设备列表
        def open_devlist_page
            dev_list_element.click
            sleep 4
        end

        #获取列表中指定mac设备的信息
        def get_data(dev_size, mac)
            for i in 0..dev_size-1
                dev_data = devlist_data_element.element.trs[i].text
                if dev_data.include?(mac)
                    dev_data =~ /(\d+\.\d+\.\d+\.\d+)\s(.+)\s(.+)/i
                    return {:ip=>$1, :dev_name=>$2, :connect_type=>$3}
                end
            end
            fail("设备列表中没有MAC地址为#{mac}所对应的数据！")
        end
    end

end
