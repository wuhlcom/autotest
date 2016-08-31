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

        operate("1、ssh登录IAM服务器；") {
            p "创建配置管理员".to_gbk
            rs = @iam_obj.manager_del_add(@ts_usr_name_config, @ts_usr_pwd_config, @ts_app_super_config_nickname, "4")
            assert_equal(1, rs["result"], "创建配置管理员失败！")

            p "创建监视管理员".to_gbk
            rs = @iam_obj.manager_del_add(@ts_usr_name_monitor, @ts_usr_pwd_monitor, @ts_app_super_monitor_nickname, "5")
            assert_equal(1, rs["result"], "创建监视管理员失败！")

            p "配置管理员登录".encode("GBK")
            @res = @iam_obj.manager_login(@ts_usr_name_config, @ts_usr_pwd_config) #管理员登录->得到uid和token
            assert_equal(@ts_usr_name_config, @res["name"], "manager name error!")
            @manage_id    = @res["uid"]
            @manage_token = @res["token"]

            p "获取所有用户列表".encode("GBK")
            rs = @iam_obj.get_user_list(@manage_id, @manage_token)
            assert(rs.nil?, "配置管理员可以获取所有用户列表")
        }

        operate("2、获取监视管理员/配置管理员token值；") {
            p "监视管理员登录".encode("GBK")
            @res = @iam_obj.manager_login(@ts_usr_name_monitor, @ts_usr_pwd_monitor) #管理员登录->得到uid和token
            assert_equal(@ts_usr_name_monitor, @res["name"], "manager name error!")
            @manage_id    = @res["uid"]
            @manage_token = @res["token"]

            p "获取所有用户列表".encode("GBK")
            rs = @iam_obj.get_user_list(@manage_id, @manage_token)
            assert(rs.nil?, "监视管理员可以获取所有用户列表")
        }

        operate("3、获取所有用户列表；") {

        }


    end

    def clearup
        operate("1.恢复默认设置") {
            @iam_obj.del_manager(@ts_usr_name_config)
            @iam_obj.del_manager(@ts_usr_name_monitor)
        }
    end

}
