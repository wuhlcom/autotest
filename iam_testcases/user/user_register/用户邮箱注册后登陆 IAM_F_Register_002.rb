#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_002", "level" => nil, "auto" => "n"}

    def prepare
        @tc_user_name2 = "tadashu@sohu.com"
        @tc_user_pwd   = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {

        }

        operate("2����¼�û��������û��Ѽ��") {
            @rs = @iam_obj.register_emailusr(@tc_user_name2, @tc_user_pwd, 1)
            assert_equal(@ts_add_rs, @rs["result"], "ʹ������ע���û�ʧ��")
            rs = @iam_obj.user_login(@tc_user_name2, @tc_user_pwd)
            assert_equal(@ts_add_rs, rs["result"], "ʹ���Ѽ����˻���¼��¼ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            @iam_obj.usr_delete_usr(@tc_user_name2, @tc_user_pwd)
        }
    end

}
