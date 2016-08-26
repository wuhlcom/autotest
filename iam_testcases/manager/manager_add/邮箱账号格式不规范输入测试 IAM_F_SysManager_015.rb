#
# description:
# 管理员查询 "zhilu123@@zhilutec.com" 管理员会报错
# author:wuhongliang
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_SysManager_015", "level" => "P4", "auto" => "n"}

    def prepare

        @tc_man_name1 = "@zhilutec.com"
        @tc_man_name2 = "zhilukeji.com"
        @tc_man_name3 = "zhiludd@.com"
        @tc_man_name4 = "zhilxxu@zhiluteccom"
        @tc_man_name5 = "zhiluuu@zhilutec."
        @tc_man_name6 = "zhiluii@zhilutec..com"
        @tc_man_name7 = "zhilu123@@zhilutec.com"
        @tc_man_names =[@tc_man_name1, @tc_man_name2, @tc_man_name3, @tc_man_name4, @tc_man_name5, @tc_man_name6, @tc_man_name7]
        @tc_nickname   = "zhilutt"
        @tc_passwd     = "123456"

    end

    def process

        operate("1、ssh登录IAM服务器；") {
        }

        operate("2、获取登录管理员的id号和token值：") {
        }

        operate("3、邮箱账号格式不规范时，新增一个账号；：") {
            #如果管理员已经存在则先删除
            @tc_man_names.each do |acc|
                puts "添加超级管理员账户为:#{acc}".to_gbk
                # @iam_obj.del_manager(acc,true)
                sleep 2
                rs = @iam_obj.manager_add(acc, @tc_nickname, @tc_passwd)
                # {"err_code":"5003","err_msg":"\u5e10\u53f7\u683c\u5f0f\u9519\u8bef","err_desc":"E_ACCOUNT_FORMAT_ERROR"}
                puts "RESULT err_msg:#{rs['err_msg']}".encode("GBK")
                puts "RESULT err_code:#{rs['err_code']}".encode("GBK")
                puts "RESULT err_desc:#{rs['err_desc']}".encode("GBK")
                assert_equal(@ts_err_accformat_code, rs["err_code"], "添加超级管理员#{acc}应提示失败!")
                assert_equal(@ts_err_accformat, rs["err_msg"], "添加超级管理员#{acc}应提示失败!")
                assert_equal(@ts_err_accformat_desc, rs["err_desc"], "添加超级管理员#{acc}应提示失败!")
            end
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            # @tc_man_names.each do |acc|
            #     puts "delete manager:#{acc}"
            #     @iam_obj.del_manager(acc)
            # end
        }
    end

}
