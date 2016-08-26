#
# description:
# author:liluping
# date:2016-07-25 10:00:17
# modify:
#
testcase {
    attr = {"id" => "IAM_F_Application_044", "level" => "P1", "auto" => "n"}

    def prepare
        @rs = ""
        @tc_app_comments = "0"
    end

    def process

        operate("1、ssh登录IAM服务器；") {
            @res = @iam_obj.manager_login #管理员登录->得到uid和token
            assert_equal(@ts_admin_usr, @res["name"], "manager name error!")
        }

        operate("2、获取知路管理员token值；") {
            @admin_id    = @res["uid"]
            @admin_token = @res["token"]
        }

        operate("3、获取修改应用的应用ID号;") {
            @client_id = @iam_obj.get_client_id(@ts_app_name_001, @admin_token, @admin_id)
        }

        operate("4、修改comments为一个字符；") {
            args = {"name"=>"#{@ts_app_name_001}","provider"=>"#{@ts_app_provider_001}","redirect_uri"=>"#{@ts_app_redirect_uri}","comments"=>"#{@tc_app_comments}"}
            @rs = @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
            assert_equal(1, @rs["result"], "modify apply comments error：#{@rs["err_desc"]}")

            #检查是否修改成功
            rs_detail = @iam_obj.apply_details(@client_id, @admin_id, @admin_token)
            assert_equal(@tc_app_comments, rs_detail["comments"], "修改comments简介后查询未修改成功！")
        }


    end

    def clearup
        operate("1.恢复默认设置") {
            if @rs["result"] == 1
                args = {"name"=>"#{@ts_app_name_001}","provider"=>"#{@ts_app_provider_001}","redirect_uri"=>"#{@ts_app_redirect_uri}","comments"=>"#{@ts_app_comments_default_001}"}
                @iam_obj.modify_apply(@admin_id, @admin_token, @client_id, args)
            end
        }
    end

}
