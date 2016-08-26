#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_062", "level" => "P2", "auto" => "n"}

    def prepare

    end

    def process

        operate("1��ssh��¼IAM��������") {
            @res = @iam_obj.manager_login #����Ա��¼->�õ�uid��token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
        }

        operate("2����ȡ֪·����Աtokenֵ��") {
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3����Ӧ������ģ����ѯ;") {
            args = {"type"=>"name", "cond"=>@ts_app_name_001}
            rs = @iam_obj.get_app_list(@admin_token, @admin_id, args)
            assert(rs["totalRows"] == "1", "��Ӧ������ģ����ѯʧ�ܣ�δ��ѯ�����ݣ�")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
