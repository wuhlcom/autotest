#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_008", "level" => "P1", "auto" => "n"}

    def prepare

    end

    def process

        operate("1��ssh��¼IAM��������") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("2����ȡ֪·����Աtokenֵ��") {

        }

        operate("3����ȡ�û�id��") {
            rs         = @iam_obj.user_login(@ts_usr_name, @ts_usr_pwd)
            @usr_token = rs["access_token"]
            @usr_id    = rs["uid"]
        }

        operate("4����ѯĳ���û�����") {
            rs = @iam_obj.get_user_details(@admin_id, @admin_token, @usr_id)
            assert_equal(@ts_usr_name, rs["account"], "��ѯ�û���ϸ��Ϣʧ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
