#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_FindPassword_017", "level" => "P4", "auto" => "n"}

    def prepare
        @tc_usr_name1    = "2194938072@qq.com"
        @tc_usr_pwd1     = "123456"
        @tc_usr_pwd1_new = "123123"
        @tc_usr_name2    = "liluping@zhilutec.com"
        @tc_usr_pwd2     = "123456"
        @tc_usr_pwd2_new = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            rs1     = @iam_obj.user_login(@tc_usr_name1, @tc_usr_pwd1)
            @uid1   = rs1["uid"]
            @token1 = rs1["access_token"]
            rs2     = @iam_obj.user_login(@tc_usr_name2, @tc_usr_pwd2)
            @uid2   = rs2["uid"]
            @token2 = rs2["access_token"]
        }

        operate("2��ʹ�ò�ͬ�������ע���û���Ȼ����������һز��ԣ���qq����") {
            rs = @iam_obj.find_pwd_for_email(@tc_usr_name1)
            assert_equal(1, rs["result"], "�����һ�ʧ��")

            rs = @iam_obj.find_pwd_for_email(@tc_usr_name2)
            assert_equal(1, rs["result"], "�����һ�ʧ��")
        }

        operate("3�������޸ģ�") {
            @rs1 = @iam_obj.mofify_user_pwd(@tc_usr_pwd1, @tc_usr_pwd1_new, @uid1, @token1)
            assert_equal(1, @rs1["result"], "�����޸�ʧ��")

            @rs2 = @iam_obj.mofify_user_pwd(@tc_usr_pwd2, @tc_usr_pwd2_new, @uid2, @token2)
            assert_equal(1, @rs2["result"], "�����޸�ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                rs1     = @iam_obj.user_login(@tc_usr_name1, @tc_usr_pwd1_new)
                @uid1   = rs1["uid"]
                @token1 = rs1["access_token"]
                @iam_obj.mofify_user_pwd(@tc_usr_pwd1_new, @tc_usr_pwd1, @uid1, @token1)
            end

            if @rs2["result"] == 1
                rs2     = @iam_obj.user_login(@tc_usr_name2, @tc_usr_pwd2_new)
                @uid2   = rs2["uid"]
                @token2 = rs2["access_token"]
                @iam_obj.mofify_user_pwd(@tc_usr_pwd2_new, @tc_usr_pwd2, @uid2, @token2)
            end
        }
    end

}
