#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Register_003", "level" => "P1", "auto" => "n"}

    def prepare
        @tc_user_name_163     = "autotest@163.com"
        @tc_user_name_qq      = "autotest@qq.com"
        @tc_user_name_126     = "autotest@126.com"
        @tc_user_name_sina    = "autotest@sina.com"
        @tc_user_name_sohu    = "autotest@sohu.com"
        @tc_user_name_yahoo   = "autotest@yahoo.com"
        @tc_user_name_gmail   = "autotest@gmail.com"
        @tc_user_name_hotmail = "autotest@hotmail.com"
        @tc_user_name_32      = "zhilukeji1zhilukeji@gamil.com"
        @tc_user_name_ul      = "zhilu123_123@gmail.com"
        @tc_user_pwd          = "123123"
    end

    def process

        operate("1��ssh��¼IAM��������") {

        }

        operate("2��ʹ������ע���û�����ʹ�ò�ͬ��������в��ԣ�") {
            p "���Գ��������Ƿ��������ע��".encode("GBK")
            p "����163����".encode("GBK")
            @rs1 = @iam_obj.register_emailusr(@tc_user_name_163, @tc_user_pwd, 1)
            assert_equal(1, @rs1["result"], "ʹ��163����ע���û�ʧ��")
            p "����qq����".encode("GBK")
            @rs2 = @iam_obj.register_emailusr(@tc_user_name_qq, @tc_user_pwd, 1)
            assert_equal(1, @rs2["result"], "ʹ��qq����ע���û�ʧ��")
            p "����126����".encode("GBK")
            @rs3 = @iam_obj.register_emailusr(@tc_user_name_126, @tc_user_pwd, 1)
            assert_equal(1, @rs3["result"], "ʹ��126����ע���û�ʧ��")
            p "����sina����".encode("GBK")
            @rs4 = @iam_obj.register_emailusr(@tc_user_name_sina, @tc_user_pwd, 1)
            assert_equal(1, @rs4["result"], "ʹ��sina����ע���û�ʧ��")
            p "����sohu����".encode("GBK")
            @rs5 = @iam_obj.register_emailusr(@tc_user_name_sohu, @tc_user_pwd, 1)
            assert_equal(1, @rs5["result"], "ʹ��sohu����ע���û�ʧ��")
            p "����yahoo����".encode("GBK")
            @rs6 = @iam_obj.register_emailusr(@tc_user_name_yahoo, @tc_user_pwd, 1)
            assert_equal(1, @rs6["result"], "ʹ��yahoo����ע���û�ʧ��")
            p "����gmail����".encode("GBK")
            @rs7 = @iam_obj.register_emailusr(@tc_user_name_gmail, @tc_user_pwd, 1)
            assert_equal(1, @rs7["result"], "ʹ��gmail����ע���û�ʧ��")
            p "����hotmail����".encode("GBK")
            @rs8 = @iam_obj.register_emailusr(@tc_user_name_hotmail, @tc_user_pwd, 1)
            assert_equal(1, @rs8["result"], "ʹ��hotmail����ע���û�ʧ��")
            p "�����������䳤��Ϊ32���ַ�".encode("GBK")
            @rs9 = @iam_obj.register_emailusr(@tc_user_name_32, @tc_user_pwd, 1)
            assert_equal(1, @rs9["result"], "ʹ�ó���Ϊ32���ַ����û���ע��ʧ��")
            p "���������������������ĸ�����֡��»��ߵ��ַ�".encode("GBK")
            @rs10 = @iam_obj.register_emailusr(@tc_user_name_ul, @tc_user_pwd, 1)
            assert_equal(1, @rs10["result"], "ʹ����ĸ�����֡��»��ߵ��ַ����û���ע��ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {
            if @rs1["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_163, @tc_user_pwd)
            end
            if @rs2["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_qq, @tc_user_pwd)
            end
            if @rs3["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_126, @tc_user_pwd)
            end
            if @rs4["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_sina, @tc_user_pwd)
            end
            if @rs5["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_sohu, @tc_user_pwd)
            end
            if @rs6["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_yahoo, @tc_user_pwd)
            end
            if @rs7["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_gmail, @tc_user_pwd)
            end
            if @rs8["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_hotmail, @tc_user_pwd)
            end
            if @rs9["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_32, @tc_user_pwd)
            end
            if @rs10["result"] == 1
                @iam_obj.usr_delete_usr(@tc_user_name_ul, @tc_user_pwd)
            end
        }
    end

}
