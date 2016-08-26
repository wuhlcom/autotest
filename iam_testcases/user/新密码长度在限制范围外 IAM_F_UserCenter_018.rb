#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_018", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_newPwd1  = "12345"
        @tc_newPwd2  = "aa12347890aa12347890aa12347890121"
        @tc_err_code = "11007"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
        }

        operate("3���޸����룬�����볤���ڷ�Χ֮�⣻") {
            @rs1 = {}
            @rs2 = {}
            p "���������������5���ַ�".encode("GBK")
            @rs1 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd1)
            assert_equal(@tc_err_code, @rs1["err_code"], "�޸�����ɹ�")
            p "���������������33���ַ�".encode("GBK")
            @rs2 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd2)
            assert_equal(@tc_err_code, @rs2["err_code"], "�޸�����ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs2["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd2, @tc_newPwd2, @ts_usr_pwd)
            elsif @rs1["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd1, @tc_newPwd1, @ts_usr_pwd)
            end
        }
    end

}
