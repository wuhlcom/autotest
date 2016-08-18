#encoding:utf-8
#iam api maneger api
#管理员接口
#author:wuhongliang
#date:2016-07-21
file_path1 = File.expand_path('../manager', __FILE__)
file_path2 = File.expand_path('../oauth', __FILE__)
file_path3 = File.expand_path('../user', __FILE__)
file_path4 = File.expand_path('../device', __FILE__)
file_path5 = File.expand_path('../js_encry', __FILE__)
require file_path1
require file_path2
require file_path3
require file_path4
require file_path5
module IAMAPI
  class IAM
    include IAMAPI::Manager
    include IAMAPI::Oauth
    include IAMAPI::User
    include IAMAPI::Device

      # #oauth 获取userid
      # #管理员登录，获取管理员Id和token-->查询应用获取应用id和应用密钥-->用户登录返回userid
      # def oauth_login_get_userid(username, pw, appname, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      #   rs_admin = manager_login(admin_usr, admin_pw) #管理员登录->得到uid和token
      #   token    = rs_admin["token"]
      #   uid      = rs_admin["uid"]
      #   oauth_get_userid(username, pw, appname, token, uid)
      # end
      #
      # #管理员查询应用获取应用id和应用密钥-->用户登录返回userid
      # def oauth_get_userid(username, pw, appname, mana_token, mana_uid, response_type=RESPONSE_TYPE)
      #   rs_app    = get_spec_app_info(mana_token, appname, mana_uid) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id
      #   client_id = rs_app["client_id"]
      #   secret    = rs_app["client_secret"]
      #   user_oauth(username, pw, secret, client_id, response_type) ##用户oauth登录,输入secret和client_id得到用户的userid
      # end
      #
      # #oauth 获取code
      # #管理员登录，获取管理员Id和token-->查询应用获取应用id和应用密钥-->用户登录获取oauthcode
      # def oauth_login_get_code(appname, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW, response_type=RESPONSE_TYPE)
      #   rs   = manager_login(admin_usr, admin_pw) #管理员登录->得到uid和token
      #   token=rs["token"]
      #   uid  =rs["uid"]
      #   oauth_get_code(appname, token, uid, response_type)
      # end
      #
      # #管理员查询应用获取应用id和应用密钥-->用户登录获取oauthcode
      # def oauth_get_code(appname, mana_token, mana_uid, response_type=RESPONSE_TYP)
      #   rs=@iam_obj.user_login(usr, pwd)
      #   uid  =rs["uid"]
      #   token=rs["access_token"]
      #   rs_app    = get_spec_app_info(mana_token, appname, mana_uid) #获取指定应用ID和密钥->输入uid和token，得到secret和client_id
      #   client_id = rs_app["client_id"]
      #   secret    = rs_app["client_secret"]
      #   user_id   = get(USERID_URL) #用户ID
      #   get_code(user_id, client_id, secret, response_type)
      # end



  end

end