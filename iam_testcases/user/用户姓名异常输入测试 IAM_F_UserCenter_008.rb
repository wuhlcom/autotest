#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_008", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_name1 = "~!@#$%^&*()_+{}:\"|<>?-=[];'\\,./"
        @tc_usr_name2 = "�й�0001"
        @tc_err_code  = "5007"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3�������û�����Ϊ�쳣�ַ���") {
            p "������������ַ�".encode("GBK")
            args = {"name" => @tc_usr_name1}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(@tc_err_code, rs["err_code"], "�û�����Ϊ�����ַ�ʱ���������ϳɹ�")
            p "�����а�������".encode("GBK")
            args = {"name" => @tc_usr_name2}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(@tc_err_code, rs["err_code"], "�û�������������ʱ���������ϳɹ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
