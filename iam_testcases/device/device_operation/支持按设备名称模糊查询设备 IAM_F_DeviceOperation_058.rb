#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_DeviceOperation_058", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_dev_name1    = "mark_dev1"
        @tc_dev_mac1     = "00:1a:31:00:01:77"
        @tc_dev_name2    = "mark_dev2"
        @tc_dev_mac2     = "00:1a:31:00:01:78"
        @tc_dev_name3    = "att_dev1"
        @tc_dev_mac3     = "00:1a:31:00:01:79"
        @tc_dev_name4    = "att_dev2"
        @tc_dev_mac4     = "00:1e:a2:00:01:51"
        @name1           = "mark"
        @name2           = "2"
        @tc_dev_name_arr = [@tc_dev_name1, @tc_dev_name2, @tc_dev_name3, @tc_dev_name4]
        @tc_dev_mac_arr  = [@tc_dev_mac1, @tc_dev_mac2, @tc_dev_mac3, @tc_dev_mac4]
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @rs= @iam_obj.phone_usr_reg(@ts_phone_usr, @ts_usr_pw, @ts_usr_regargs)
            assert_equal(@ts_add_rs, @rs["result"], "用户#{@ts_phone_usr}注册失败")

            @tc_dev_name_arr.each_with_index do |name, index|
                rs = @iam_obj.usr_add_devices(name, @tc_dev_mac_arr[index], @ts_phone_usr, @ts_usr_pw)
                assert_equal(@ts_add_rs, rs["result"], "用户#{name}增加设备失败,设备mac为:#{@tc_dev_mac_arr[index]}")
            end
        }

        operate("2、获取登录用户uid号；") {
            p "对设备名称进行模糊查询".to_gbk
            args = {"type" => "name", "cond" => @name1}
            rs   = @iam_obj.usr_get_devlist(@ts_phone_usr, @ts_usr_pw, args)
            dev_name = []
            rs["resList"].each do |device|
                dev_name << device["device_name"]
            end
            flag = false
            flag = true if rs["resList"].size == 2 && dev_name.include?(@tc_dev_name1) && dev_name.include?(@tc_dev_name2)
            assert(flag, "未查询到相关设备")
        }

        operate("3、查询设备名称带有知路字段的设备信息；") {
            args = {"type" => "name", "cond" => @name2}
            rs   = @iam_obj.usr_get_devlist(@ts_phone_usr, @ts_usr_pw, args)
            dev_name = []
            rs["resList"].each do |device|
                dev_name << device["device_name"]
            end
            flag = false
            flag = true if rs["resList"].size == 2 && dev_name.include?(@tc_dev_name2) && dev_name.include?(@tc_dev_name4)
            assert(flag, "未查询到相关设备")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @tc_dev_name_arr.each do |name|
                @iam_obj.usr_delete_device(name, @ts_phone_usr, @ts_usr_pw)
            end
            @iam_obj.usr_delete_usr(@ts_phone_usr, @ts_usr_pw)
        }
    end

}
