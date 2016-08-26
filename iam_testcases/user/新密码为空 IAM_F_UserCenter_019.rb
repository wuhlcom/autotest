#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_019", "level" => "P2", "auto" => "n"}

    def prepare
        @tc_err_code = "11007"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {

        }

        operate("3���޸����룬������Ϊ�գ�") {
            @rs1 = {}
            p "���������������5���ַ�".encode("GBK")
            @rs1 = @iam_obj.usr_modify_pw_step(@ts_usr_name, @ts_usr_pwd, @ts_usr_pwd, "")
            assert_equal(@tc_err_code, @rs1["err_code"], "�޸�����ɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.usr_modify_pw_step(@ts_usr_name, "", "", @ts_usr_pwd)
            end
        }
    end

}
