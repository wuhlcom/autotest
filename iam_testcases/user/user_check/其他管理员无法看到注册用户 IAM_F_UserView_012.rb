#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_UserView_012", "level" => "P3", "auto" => "n"}

    def prepare

    end

    def process

        operate("1��ssh��¼IAM��������") {
            p "���ù���Ա��¼".encode("GBK")
            @res = @iam_obj.manager_login(@ts_usr_name_config, @ts_usr_pwd_config) #����Ա��¼->�õ�uid��token
            assert_equal(@ts_usr_name_config, @res["name"], "manager name error!")
            @manage_id    = @res["uid"]
            @manage_token = @res["token"]

            p "��ȡ�����û��б�".encode("GBK")
            rs = @iam_obj.get_user_list(@manage_id, @manage_token)
            assert(rs.nil?, "���ù���Ա���Ի�ȡ�����û��б�")
        }

        operate("2����ȡ���ӹ���Ա/���ù���Աtokenֵ��") {
            p "���ӹ���Ա��¼".encode("GBK")
            @res = @iam_obj.manager_login(@ts_usr_name_monitor, @ts_usr_pwd_monitor) #����Ա��¼->�õ�uid��token
            assert_equal(@ts_usr_name_monitor, @res["name"], "manager name error!")
            @manage_id    = @res["uid"]
            @manage_token = @res["token"]

            p "��ȡ�����û��б�".encode("GBK")
            rs = @iam_obj.get_user_list(@manage_id, @manage_token)
            assert(rs.nil?, "���ӹ���Ա���Ի�ȡ�����û��б�")
        }

        operate("3����ȡ�����û��б�") {

        }


    end

    def clearup
        operate("1.�ָ�Ĭ������") {

        }
    end

}
