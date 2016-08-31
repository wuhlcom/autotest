#
# description:
# author:lilupng
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_069", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_usr      = "autotest_newapp"
        @tc_app_provider = "autotest"
        @tc_app_red_uri  = "http://192.168.10.9"
        @tc_phone_usr    = "15834031512"
        @tc_usr_pw       = "123456"
        @tc_usr_regargs  = {type: "account", cond: @tc_phone_usr}
        @tc_args         = {name: @tc_app_usr, provider: @tc_app_provider, redirect_uri: @tc_app_red_uri, comments: ""}
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            rs= @iam_obj.phone_usr_reg(@tc_phone_usr, @tc_usr_pw, @tc_usr_regargs)
            assert_equal(@ts_add_rs, rs["result"], "用户#{@tc_phone_usr}注册失败")
        }

        operate("2、获取知路管理员token值；") {
        }

        operate("3、获取要删除应用ID号，其中该应用已绑定用户；") {
            p "创建一个新应用".encode("GBK")
            rs = @iam_obj.qca_app(@tc_args[:name], @tc_args, "1")
            assert_equal(1, rs["result"], "创建应用#{@tc_args[:name]}失败！")

            p "应用绑定用户".encode("GBK")
            rs_bind = @iam_obj.usr_qb_app(@tc_phone_usr, @tc_usr_pw, @tc_app_usr)
            assert_equal(1, rs_bind["result"], "应用绑定用户失败！")
        }

        operate("4、删除该应用；") {
            tip = "删除绑定用户的应用"
            rs  = @iam_obj.mana_del_app(@tc_app_usr)
            puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
            puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
            puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
            assert_equal(@ts_err_delapp_code, rs["err_code"], "#{tip}返回code错误!")
            assert_equal(@ts_err_delapp_msg, rs["err_msg"], "#{tip}返回msg错误")
            assert_equal(@ts_err_delapp_desc, rs["err_desc"], "#{tip}返回desc错误!")

        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.usr_qub_app(@tc_phone_usr, @tc_usr_pw, @tc_app_usr)
            @iam_obj.mana_del_app(@tc_app_usr)
            @iam_obj.usr_delete_usr(@tc_phone_usr, @tc_usr_pw)
        }
    end

}
