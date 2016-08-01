#encoding:utf-8
module IAMAPI
    VERSION      = '1.0.0'
    RESPONSE_TYPE= "code"
    APP_URL      = "http://192.168.10.9:8082/apps?" #app
    MANAGER_LOG_URL    = "http://192.168.10.9:8082/admins/dologin" #管理员登录
    APPNAME      = "IAMAPI_IAM_F_OAuth_019"
    USER_NAME    = "13760281579" #注册用户名
    #123456对应的密码
    ENCRYPT_PWD  = "9c76736d8a993299e155c797861d14ef7cd3507c900527e11da5d3357872ba9fb9e2db9511fe2bfafe7a6d4c6f8efdac40425414639e4815069c380c86ef4a7dd121e7db0418919a3ca8de77d745269ad19ea117154411df35f840eb1af5e82383c2d6dc627b3654f15596959e1643707995e9ef3db2847c0ca60de50ac43fc0" #用户密码

    OAUTH_URL   = "http://192.168.10.9:8082/index.php/Oauth/authorize"
    OAUTH_F_URL = "http://192.168.10.9:8082/index.php/Oauth/finishAuthorization"

    REDIRECT_URL        ="http://192.168.10.9:8083/index.php/Login/index" #重定向
    USERID_URL          ="http://192.168.10.9:8082/userid.txt" #获取用户id
    CODE_URL            ="http://192.168.10.9:8082/code.txt" #获取用户code

    # curl -X POST http://192.168.10.9:8082/mobileCode/18676710461
    MOBILECODE_URL      = "http://192.168.10.9:8082/mobileCode/" #手机验证码，包括手机管理员和手机用户

    # curl -X POST http://192.168.10.9:8082/index.php/Admins/modpwdByMobile -d 'name=18676710461&password=123456&code=9791'
    MANAGER_MODPW_MOB_URL = "http://192.168.10.9:8082/index.php/Admins/modpwdByMobile" #手机管理员修改密码

    # curl -X POST http://192.168.10.9:8082/users/adduser -d 'account=13923791162&pwd=123123&type=phone&code=1111'
    # curl -X POST http://192.168.10.9:8082/users/adduser -d 'account=349160920@126.com&pwd=123123&type=email'
    USER_REG_URL        = "http://192.168.10.9:8082/users/adduser" #用户注册URL
    # curl -X POST http://192.168.10.9:8082/index.php/users/modpwdByMobile -d 'account=13923791162&password=123123&code=1234'
    USER_MODPW_MOB_URL  = "http://192.168.10.9:8082/index.php/users/modpwdByMobile" #手机用户修改密码地址

end