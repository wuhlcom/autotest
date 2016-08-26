#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_010", "level" => "P2", "auto" => "n"}

    def prepare

    end

    def process

        operate("1��ssh��¼IAM��������") {

        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3����ȡ�����û��б�") {
            rs = @iam_obj.get_user_list(@admin_id, @admin_token)
            refute(rs["users"].empty?, "��ȡ�����û��б�ʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
