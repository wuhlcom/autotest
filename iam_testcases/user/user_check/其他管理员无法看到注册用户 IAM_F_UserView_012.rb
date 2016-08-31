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
            p "�������ù���Ա".to_gbk
            rs = @iam_obj.manager_del_add(@ts_usr_name_config, @ts_usr_pwd_config, @ts_app_super_config_nickname, "4")
            assert_equal(1, rs["result"], "�������ù���Աʧ�ܣ�")

            p "�������ӹ���Ա".to_gbk
            rs = @iam_obj.manager_del_add(@ts_usr_name_monitor, @ts_usr_pwd_monitor, @ts_app_super_monitor_nickname, "5")
            assert_equal(1, rs["result"], "�������ӹ���Աʧ�ܣ�")

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
            @iam_obj.del_manager(@ts_usr_name_config)
            @iam_obj.del_manager(@ts_usr_name_monitor)
        }
    end

}
