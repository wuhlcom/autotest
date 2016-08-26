#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_020", "level" => "P1", "auto" => "n"}

    def prepare
        # 电信号段:133/153/180/181/189/177；
        # 联通号段:130/131/132/155/156/185/186/145/176；
        # 移动号段：134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
        @tc_phone_nums=[]
        # 130-139  #180-189 # 150-153 155-159
        10.times do |num|
            @tc_phone_nums.push "13#{num}66668888"
            @tc_phone_nums.push "18#{num}66668888"
            @tc_phone_nums.push "15#{num}66668888" unless num == "4"
        end
        # 145 147 176 177 178
        str = "66668888"
        @tc_phone_nums.push "145#{str}", "147#{str}", "176#{str}", "177#{str}", "178#{str}"
        @tc_phone_nums.sort!
        @tc_nickname1 = "phone_account"
        @tc_passwd    = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、使用不同手机段号码新增一个管理员：") {
            #如果管理员已经存在则先删除
            @tc_phone_nums.each do |phone_num|
                @iam_obj.del_manager(phone_num)
                puts "添加超级管理员账户为:'#{phone_num}'".to_gbk
                rs = @iam_obj.manager_add(phone_num, @tc_nickname1, @tc_passwd)
                # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
                puts "RESULT MSG:#{rs['msg']}".encode("GBK")
                assert_equal(@ts_add_rs, rs["result"], "添加超级管理员'#{phone_num}'失败!")
                assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员'#{phone_num}'失败!")
            end
        }


    end

    def clearup

        operate("1.恢复默认设置") {
            @tc_phone_nums.each do |phone_num|
                puts "delete manager '#{phone_num}'"
                @iam_obj.del_manager(phone_num)
            end
        }

    end

}
