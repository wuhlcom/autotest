#
# description:
# author:liluping
# date:2016-07-25 10:00:18
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserCenter_005", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_usr_name1 = "��"
        @tc_usr_name2 = "��������������������������������"
        @tc_usr_name3 = "AaAaAaAaAaAaAaAa"
    end

    def process

        operate("1��ssh��¼IAM��������") {
        }

        operate("2����¼�û���ȡaccess_tokenֵ��uid�ţ�") {
            rs     = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @uid   = rs["uid"]
            @token = rs["access_token"]
        }

        operate("3�������û����������ġ���ĸ����") {
            p "��������1������".encode("GBK")
            args = {"name" => @tc_usr_name1}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(1, rs["result"], "�޸��û�����Ϊ1������ʱʧ�ܣ�")
            p "��������16������".encode("GBK")
            args = {"name" => @tc_usr_name2}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(1, rs["result"], "�޸��û�����Ϊ16������ʱʧ�ܣ�")
            p "��������16����ĸ".encode("GBK")
            args = {"name" => @tc_usr_name3}
            rs   = @iam_obj.usr_modify(@uid, @token, args)
            assert_equal(1, rs["result"], "�޸��û�����Ϊ16����ĸʱʧ�ܣ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
