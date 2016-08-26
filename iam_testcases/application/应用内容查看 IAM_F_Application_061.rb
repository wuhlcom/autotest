#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_061", "level" => "P2", "auto" => "n"}

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

        operate("3����ȡӦ���б�;") {
            rs = @iam_obj.get_app_list(@admin_token, @admin_id)
            rs_app = rs["apps"][0]
            rs_flag = rs_app.has_key?("client_id") && rs_app.has_key?("client_secret") && rs_app.has_key?("name") && rs_app.has_key?("provider") && rs_app.has_key?("status")
            assert(rs_flag, "Ӧ���б���ʾ���ݲ���ȷ��")
        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
