#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_066", "level" => "P3", "auto" => "n"}

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

        operate("3����Ӧ�����Ʋ�ѯcondֵΪ�����ַ�;") {
            args = {"type" => "name", "cond" => "^&%*$"}
            res  = @iam_obj.get_app_list(@admin_token, @admin_id, args)
            assert(res["totalRows"]=="0", "��Ӧ�����Ʋ�ѯcondֵΪ�����ַ�ʱ��δ���ؿ�ֵ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
