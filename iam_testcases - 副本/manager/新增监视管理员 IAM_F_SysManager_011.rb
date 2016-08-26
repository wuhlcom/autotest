#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_011", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_man_name = "autotest_whl4@zhilutec.com"
        @tc_nickname     = "autotest_whl4"
        @tc_passwd       = "123456"
        @tc_manager_type = "5"
    end

    def process

        operate("1、ssh登录到IAM服务器；") {
        }

        operate("2、获取知路管理员token值；") {
            #如果管理员已经存在则先删除
            @iam_obj.del_manager(@tc_man_name)
        }

        operate("2、新增超级管理员；") {
            rs = @iam_obj.manager_add(@tc_man_name, @tc_nickname, @tc_passwd, @tc_manager_type)
            puts "RESULT MSG:#{rs['msg']}".encode("GBK")
            assert_equal(@ts_add_rs, rs["result"], "添加监视管理员失败!")
            assert_equal(@ts_add_msg, rs["msg"], "添加监视管理员失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name)
        }
    end

}
