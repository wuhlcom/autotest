#
# description:
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_034", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_man_name1 = "15810018888"
        @tc_nickname1 = "niubee"
        @tc_passwd    = "123456"
        @tc_rcode     = ""
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、新增一个管理员，role_code为空；") {
            @iam_obj.del_manager(@tc_man_name1)
            puts "添加超级管理员账户为:#{@tc_man_name1}，昵称为'#{@tc_nickname1}'".to_gbk
            p rs = @iam_obj.manager_add(@tc_man_name1, @tc_nickname1, @tc_passwd, @tc_rcode)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_roleid_code, rs["err_code"], "添加超级管理员#{@tc_man_name1}失败!")
            assert_equal(@ts_err_roleid, rs["err_msg"], "添加超级管理员#{@tc_man_name1}失败!")
            assert_equal(@ts_err_roleid_desc, rs["err_desc"], "添加超级管理员#{@tc_man_name1}失败!")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@tc_man_name1)
        }
    end

}
