#encoding:utf-8
module IAMAPI
  IAM_HOST          = "192.168.10.9"
  IAM_PORT          = "8082"
  REDIRECT_PORT     = "8083"
  API_ADDR          = "http://#{IAM_HOST}:#{IAM_PORT}/"
  REDIRECT_ADDR     = "http://#{IAM_HOST}:#{REDIRECT_PORT}/"
  ADMIN_USR         = "admin@zhilutec.com"
  ADMIN_PW          = "123123"
  VERSION           = '1.0.0'
  RESPONSE_TYPE     = "code"
  APP_URL           = "#{API_ADDR}apps?" #app
  MANAGER_LOG_URL   = "#{API_ADDR}admins/dologin" #管理员登录
  MANAGER_ADD_URL   = "#{API_ADDR}index.php/admins/add" #添加管理员接口地址
  MANAGER_INDEX_URL = "#{API_ADDR}index.php/admins/index" #查询管理员接口地址
  MANAGER_DEL_URL   = "#{API_ADDR}index.php/admins/del" #删除管理员接口地址

  #oath
  OAUTH_URL         = "#{API_ADDR}index.php/Oauth/authorize"
  OAUTH_F_URL       = "#{API_ADDR}index.php/Oauth/finishAuthorization"
  # curl http://192.168.10.9:8082/index.php/Oauth/access_token -d "client_id=160603714647&client_secret=zJsqR9XiRaJQzDjpxxpqgS3FAq0Equkp&grant_type=authorization_code&
  # code=f83fb7f4db89231a939f8ca56f5670ae&redirect_uri=http://192.168.10.9:8083/index.php/Login/index"
  OAUTH_TOKEN_URL   = "#{API_ADDR}index.php/Oauth/access_token" #获取用户 access_code
  # http://192.168.10.9:8082/index.php/Resource/userinfo/
  OAUTH_USRINFO_URL = "#{API_ADDR}index.php/Resource/userinfo/" #获取用户 usr_info

  REDIRECT_URL          ="#{REDIRECT_ADDR}index.php/Login/index" #重定向
  USERID_URL            ="#{API_ADDR}userid.txt" #获取用户id
  CODE_URL              ="#{API_ADDR}code.txt" #获取用户code


  # curl -X POST #{API_ADDR}mobileCode/18676710461
  MOBILECODE_URL        = "#{API_ADDR}mobileCode/" #手机验证码，包括手机管理员和手机用户

  # curl -X POST #{API_ADDR}index.php/Admins/modpwdByMobile -d 'name=18676710461&password=123456&code=9791'
  MANAGER_MODPW_MOB_URL = "#{API_ADDR}index.php/Admins/modpwdByMobile" #手机管理员修改密码
  MANAGER_INFO_MOD_URL  = "#{API_ADDR}index.php/admins/edit" #修改管理员信息
  # curl -X POST http://192.168.10.9:8082/index.php/Admins/modPersonPwd -d 'uid=11&oldpwd=123123&newpwd=654321&token=01e7cbf4fa19d6a7d0ed2b3622605686'
  MANAGER_MODPW_URL     = "#{API_ADDR}index.php/Admins/modPersonPwd" #修改管理员密码

  # curl -X POST #{API_ADDR}users/adduser -d 'account=13923791162&pwd=123123&type=phone&code=1111'
  # curl -X POST #{API_ADDR}users/adduser -d 'account=349160920@126.com&pwd=123123&type=email'
  USER_REG_URL          = "#{API_ADDR}users/adduser" #用户注册URL
  # curl -X POST #{API_ADDR}index.php/users/modpwdByMobile -d 'account=13923791162&password=123123&code=1234'
  USER_MODPW_MOB_URL    = "#{API_ADDR}index.php/users/modpwdByMobile" #手机用户修改密码地址
  # curl -X POST http://192.168.10.9:8091/index.php/users/modpwd -d'name=895344033@qq.com&token=6C1GAWdn6EaYruv14z9vzE9oxLj3sUhY&password=654321'
  USER_MODPW_EMAIL_URL  = "#{API_ADDR}index.php/users/modpwd"

  # curl -X POST #{API_ADDR}index.php/Admins/findPwdToken -d 'account=349160920@126.com'
  MANAGER_EMTOKEN_URL   = "#{API_ADDR}index.php/Admins/findPwdToken" #修改邮箱账户时获取token地址
  #curl -X POST #{API_ADDR}index.php/Admins/modpwd -d 'name=895344033@qq.com&token=sD0vWtEDzZUMI5mS3BMh5zzUh3Faxemq&password=654321'
  MANAGER_MODPW_EM_URL  = "#{API_ADDR}index.php/Admins/modpwd" #修改邮箱账户密码地址

  USER_LOGIN_URL    = "#{API_ADDR}index.php/users/userlogin" #用户登录
  USER_APP_URL      = "#{API_ADDR}userApps?" #user_app
  # curl -X GET "http://192.168.10.9:8082/userApps/valid?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=efaa91c3491d362a5d9dc3e90fa1e9ed"
  USER_APP_LIST_URL = "http://192.168.10.9:8082/userApps/valid?"
  # curl -X PUT http://192.168.10.9:8082/apps/status?admin_id=1&token=xxxx -d '{"id":"160408322740,160408513385","status":"1"}'
  APP_ACTIVE_URL    = "#{API_ADDR}apps/status?"
  #curl -X GET "http://192.168.10.9:8082/appFiles?client_id=160517937222"
  APPFILES_URL      = "#{API_ADDR}appFiles?" #管理员配置应用进程

  USER_DEVICES_URL        = "#{API_ADDR}userDevices"
  # curl "http://192.168.10.9:8082/deviceApps/binding" -d '{"device_id":"c236411f466e09f0","client_id":[]}'
  DEVICES_APP_BINDING_URL = "#{API_ADDR}deviceApps/binding"
  #  # curl -X GET "http://192.168.10.165/cloudac/index.php/service/getDeviceID?mac=00:08:D2:00:3A:27"
  DEVICE_ID_URL           = "http://192.168.10.165:81/cloudac/index.php/service/getDeviceID?"
  # curl -X GET "http://192.168.10.9:8082/deviceApps?device_id=9d887400f65f699"
  DEVICE_APPS_URL         = "#{API_ADDR}deviceApps?" #查看设备绑定了哪些应用

  # curl -X GET "http://192.168.10.9:8082/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67"
  USER_LIST_URL           = "#{API_ADDR}users?"
  # curl -X GET "http://192.168.10.9:8082/index.php/Users/detail?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&id=a7dff902-b80b-4cd7-9208-cdd856bddcd0"
  USER_DETAIL_URL         = "#{API_ADDR}index.php/Users/detail?"

  # curl -X POST http://192.168.10.9:8082/index.php/users/findPwdToken -d 'account=349160920@qq.com'
  USER_FIND_PWD_URL       = "#{API_ADDR}index.php/users/findPwdToken"
  # curl -X POST http://192.168.10.9:8081/index.php/users/modPersonPwd -d 'oldpwd=123123&newpwd=321321&uid=123456&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
  USER_MODPW_URL          = "#{API_ADDR}index.php/users/modPersonPwd"

  # curl -X POST http://192.168.10.9:8082/index.php/users/profile -d 'name=test&sex=1&qq=349160920&phone=13923791162&email=136@126.com&uid=123454&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
  USER_PROFILE_URL        = "#{API_ADDR}index.php/users/profile"
  # curl -X GET "http://192.168.10.9:8082/deviceApps/appList"
  USER_APPLIST_URL        = "#{API_ADDR}deviceApps/appList"
  # curl -X POST http://192.168.10.9:8082/users/deluser -d '{"ids":"480f30b6-0f51-44e8-b3c0-d9db22557b6a,828a6550-4173-4ffa-805d-f71c4b86ec02"}'
  USER_DEL_URL            = "#{API_ADDR}users/deluser"
end