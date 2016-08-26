#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_017", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_newPwd1 = "123456"
        @tc_newPwd2 = "aa12347890aa12347890aa1234789012"
        @tc_newPwd3 = "123__22Aa"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
        }

        operate("3���޸�����Ϊ�����룻") {
            p "�������������6���ַ�".encode("GBK")
            @rs1 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, @tc_newPwd1)
            assert_equal(1, @rs1["result"], "�޸�����ʧ��")
            p "���������������32���ַ�".encode("GBK")
            @rs2 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd1, @tc_newPwd1, @tc_newPwd2)
            assert_equal(1, @rs2["result"], "�޸�����ʧ��")
            p "�����������������»����ַ�".encode("GBK")
            @rs3 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @tc_newPwd2, @tc_newPwd2, @tc_newPwd3)
            assert_equal(1, @rs3["result"], "�޸�����ʧ��")
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
