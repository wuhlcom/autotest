#encoding:utf-8
#iam api maneger api
#管理员接口
#author:wuhongliang
#date:2016-07-21
file_path1 = File.expand_path('../manager', __FILE__)
file_path2 = File.expand_path('../oauth', __FILE__)
file_path3 = File.expand_path('../user', __FILE__)
require file_path1
require file_path2
require file_path3
module IAMAPI
    class IAM
        include IAMAPI::Manager
        include IAMAPI::Oauth
        include IAMAPI::User
        #oauth 获取userid
        def oauth_get_userid(response_type=RESPONSE_TYPE, appname=APPNAME, username=USER_NAME, oauth_url=OAUTH_URL, admin_url=ADMIN_URL, app_url=APP_URL, encrypt_pwd=ENCRYPT_PWD)
            rs        = manager_login(admin_url) #管理员登录->得到uid和token
            rs_app    = get_spec_app_info(rs["token"], appname, app_url, rs["uid"]) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id
            client_id = rs_app["client_id"]
            secret    = rs_app["client_secret"]
            user_oauth(username, encrypt_pwd, secret, client_id, oauth_url, response_type) ##用户oauth登录,输入secret和client_id得到用户的userid
        end

        #oauth 获取code
        def oauth_get_code(response_type=RESPONSE_TYPE, appname=APPNAME, admin_url=ADMIN_URL, app_url=APP_URL)
            rs        = manager_login(admin_url) #管理员登录->得到uid和token
            rs_app    = get_spec_app_info(rs["token"], appname, app_url, rs["uid"]) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id
            client_id = rs_app["client_id"]
            secret    = rs_app["client_secret"]
            user_id   = get(USERID_URL) #用户ID
            get_code(user_id, client_id, secret, response_type, OAUTH_F_URL)
        end
    end

end