#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_068", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_app_usr1 = "autotest_app1"
        @tc_app_usr2 = "autotest_app2"
        @tc_app_provider  = "autotest"
        @tc_app_red_uri   = "http://192.168.10.9"
        @tc_app_comments  = ""
        @tc_err_code      = "22013"

        @tc_app_names     = [@tc_app_usr1, @tc_app_usr2]
        @tc_account_arr   = [@ts_app_super_manage, @ts_app_system_manage]
        @tc_usr_part      = {provider: @tc_app_provider, redirect_uri: @tc_app_red_uri, comments: @tc_app_comments}
        @tc_usr_args      = []
        @tc_app_names.each do |tc_usr_name|
            args = {name: tc_usr_name}
            args = args.merge(@tc_usr_part)
            @tc_usr_args<<args
        end
    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取知路管理员token值；") {
            p "创建一个超级管理员账户".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_super_manage, @ts_app_manage_pwd, @ts_app_super_manage_nickname)
            assert_equal(@ts_add_rs, rs["result"], "创建超级管理员#{@ts_app_super_manage}失败！")
            p "创建一个系统管理员账户".encode("GBK")
            rs = @iam_obj.manager_del_add(@ts_app_system_manage, @ts_app_manage_pwd, @ts_app_system_manage_nickname, "3")
            assert_equal(@ts_add_rs, rs["result"], "创建系统管理员#{@ts_app_system_manage}失败！")
        }

        operate("3、获取要删除应用ID号；") {
            p "创建两个新应用".encode("GBK")
            @tc_usr_args.each do |args|
                rs = @iam_obj.qca_app(args[:name], args, "0", @ts_app_super_manage, @ts_app_manage_pwd)
                assert_equal(@ts_add_rs, rs["result"], "管理员创建应用#{args[:name]}失败")
            end
        }

        operate("4、知路管理员删除该应用；") {
            rs = @iam_obj.mana_del_app(@tc_app_usr1, nil, @ts_app_super_manage, @ts_app_manage_pwd)
            assert_equal(1, rs["result"], "超级管理员删除应用失败！")
        }

        operate("5、登录一个系统管理员，获取该系统管理员的token值；") {

        }

        operate("6、系统管理员删除一个应用；") {
            tip  = "系统管理员删除一个应用"
            rs = @iam_obj.mana_del_app(@tc_app_usr2, nil, @ts_app_system_manage, @ts_app_manage_pwd)
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
            @iam_obj.mana_del_app(@tc_app_usr1)
            @iam_obj.mana_del_app(@tc_app_usr2)

            @iam_obj.del_manager(@ts_app_super_manage)
            @iam_obj.del_manager(@ts_app_system_manage)
        }
    end

}
