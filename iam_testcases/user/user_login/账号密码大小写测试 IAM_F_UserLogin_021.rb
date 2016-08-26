#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserLogin_001", "level" => "P3", "auto" => "n"}

    def prepare
        @tc_usr_name    = "liluping@zhilutec.com"
        @tc_usr_pwd     = "123456"
        @tc_usr_pwd_new = "liluping"
        @tc_err_code    = "10001"
    end

    def process

        operate("1��ssh��¼IAM��������") {
            @rs = @iam_obj.user_login(@tc_usr_name, @tc_usr_pwd)
            @md = @iam_obj.mofify_user_pwd(@tc_usr_pwd, @tc_usr_pwd_new, @rs["uid"], @rs["access_token"])
            assert_equal(1, @md["result"], "�޸�����Ϊ��ĸ����ʱʧ��")
        }

        operate("2���û���¼���˺š��������뺬�д�Сд��ĸ��") {
            rs = @iam_obj.user_login(@tc_usr_name.upcase, @tc_usr_pwd_new.upcase)
            assert_equal(@tc_err_code, rs["err_code"], "�˺����뺬�д�Сд��ĸ��¼ʱ��¼�ɹ������ǵ�¼ʧ�ܵ��Ƿ��صĴ����벻��ȷ")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @md["result"] == 1
                rs = @iam_obj.user_login(@tc_usr_name, @tc_usr_pwd_new)
                @iam_obj.mofify_user_pwd(@tc_usr_pwd_new, @tc_usr_pwd, rs["uid"], rs["access_token"])
            end
        }
    end

}
