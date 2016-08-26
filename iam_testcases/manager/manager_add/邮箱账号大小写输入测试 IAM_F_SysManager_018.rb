#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_018", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_man_name1 = "IAMAPIsys_manager@ZHIlu.Com"
        @tc_man_name2 = @tc_man_name1.upcase
        @tc_man_name3 = @tc_man_name1.downcase
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3]
        @tc_nickname   = "SysManager_018"
        @tc_passwd     = "123456"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、执行新增一个管理员：") {
            #如果管理员已经存在则先删除
            @tc_man_names.each do |acc|
                @iam_obj.del_manager(acc)
                puts "添加超级管理员账户为:#{acc}".to_gbk
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwd)
                # {"result":1,"msg":"\u6dfb\u52a0\u6210\u529f"}
                puts "RESULT MSG:#{rs['msg']}".encode("GBK")
                assert_equal(@ts_add_rs, rs["result"], "添加超级管理员#{acc}失败!")
                assert_equal(@ts_add_msg, rs["msg"], "添加超级管理员#{acc}失败!")
            end
        }

    end

    def clearup

        operate("1.恢复默认设置") {
            @tc_man_names.each do |acc|
                @iam_obj.del_manager(acc)
            end
        }

    end

}
