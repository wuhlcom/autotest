#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_020", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_newPwd1  = "�й��й��й�"
        @tc_newPwd2  = "!@\#$*("
        @tc_newPwd3  = "������������"
        @tc_err_code = "11007"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {

        }

        operate("3���޸����룬�����������쳣��") {
            p "������������".encode("GBK")
            @rs1 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd1)
            assert_equal(@tc_err_code, @rs1["err_code"], "�޸�����ɹ�")
            p "�������������ַ�".encode("GBK")
            @rs2 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd2)
            assert_equal(@tc_err_code, @rs2["err_code"], "�޸�����ɹ�")
            p "��������ȫ�Ǹ�ʽ����".encode("GBK")
            @rs3 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd3)
            assert_equal(@tc_err_code, @rs3["err_code"], "�޸�����ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs3["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd3, @tc_newPwd3, @ts_usr_pwd)
            elsif @rs2["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd2, @tc_newPwd2, @ts_usr_pwd)
            elsif @rs1["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd1, @tc_newPwd1, @ts_usr_pwd)
            end
        }
    end

}
