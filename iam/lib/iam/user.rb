#encoding:utf-8
#iam api maneger api
#用户接口
#author:wuhongliang
#date:2016-07-21
file_path = File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
  module User
    include IAMAPI::PubSocket
    # curl -X POST http://192.168.10.9:8092/users/adduser -d 'account=13923791162&pwd=123123&type=phone&code=1111'
    # curl -X POST http://192.168.10.9:8092/users/adduser -d 'account=349160920@126.com&pwd=123123&type=email'
    def data_register_user(phone, pw, type, code=nil)
      data = "account=#{phone}&pwd=#{pw}&type=#{type}"
      if type=="phone"
        data = "#{data}&code=#{code}"
      elsif type=="email"
        data
      else
        fail "register type error!"
      end
      data
    end

    def register_user(phone, pw, type, code=nil, url=USER_REG_URL)
      data=data_register_user(phone, pw, type, code)
      rs  = post_data(url, data)
      JSON.parse(rs)
    end

    def register_phoneusr(phone, pw)
      type   ="phone"
      rs_code=request_mobile_code(phone) #请求验证码
      sleep 2
      register_user(phone, pw, type, rs_code["code"])
    end


    # curl -X POST http://192.168.10.9:8092/index.php/users/modpwdByMobile -d 'account=13923791162&password=123123&code=1234'
    def data_usr_modpw_mobile(phone, pw, code)
      data = "account=#{phone}&password=#{pw}&code=#{code}"
    end

    #获取验证码->修改密码
    def usr_modpw_mobile(phone, pw, url=USER_MODPW_MOB_URL)
      rs_code = request_mobile_code(phone)
      data    = data_usr_modpw_mobile(phone, pw, rs_code["code"])
      rs      = post_data(url, data)
      JSON.parse(rs)
    end

    #用户登录
    # curl -X POST http://192.168.10.9:8082/index.php/users/userlogin -d 'account=349160920@qq.com&pwd=123123&client_id=100000000000'
    # return,hash
    # {"result"=>1, "uid"=>"eb4bb4d2-e4c8-4a15-940f-91abb2ab418c", "account"=>"13760281579", "access_token"=>"b7424a90153e768068eb389a583f656f"}
    def user_login(usr, pwd, url=USER_LOGIN_URL)
      data = "account=#{usr}&pwd=#{pwd}&client_id=100000000000"
      rs   = post_data(url, data)
      JSON.parse(rs) unless rs.empty?
    end

    # 用户查询可用所有可用应用列表
    # curl -X GET "http://192.168.10.9:8092/userApps/valid?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=efaa91c3491d362a5d9dc3e90fa1e9ed"
    # return,hash
    #  {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    # "apps"=>[{"client_id"=>"160816380356", "name"=>"test_app", "provider"=>"provider", "status"=>"1", "comments"=>"oauth", "create_time"=>"1471334295", "open_id"=>""}]}
    def user_app_list_all(id, token, flag=false, url=USER_APP_LIST_URL, ip=IAM_HOST, port=IAM_PORT)
      rs = ""
      if flag
        path = "/userApps/valid?id=#{id}&token=#{token}"
        rs   =get(ip, path, port)
      else
        url = "#{url}id=#{id}&token=#{token}"
        rs  = get(url)
      end
      if rs.nil?||rs.empty?
        puts "IAM Socket bugs!Return value format error!"
        rs = false
      else
        JSON.parse(rs)
      end
    end

    #用户登录-查询可用所有可用应用列表
    def usr_login_list_app_all(usr, pwd, flag=false)
      rs   = user_login(usr, pwd)
      id   =rs["uid"]
      token=rs["token"]
      user_app_list_all(id, token, flag)
    end

    #用户查询可用应用列表
    # curl -X GET "http://192.168.10.9:8082/userApps/valid?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=efaa91c3491d362a5d9dc3e90fa1e9ed&type=name&cond=test""
    # type,string,"name","provider","comments","redirect_url"
    # return,hash
    #  {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    # "apps"=>[{"client_id"=>"160816380356", "name"=>"test_app", "provider"=>"provider", "status"=>"1", "comments"=>"oauth", "create_time"=>"1471334295", "open_id"=>""}]}
    # flag,ture支持中文应用名查询
    def user_app_list_bytype(cond, id, token, flag=false, type="name", url=USER_APP_LIST_URL, ip=IAM_HOST, port=IAM_PORT)
      rs = ""
      if flag
        path = "/userApps/valid?id=#{id}&token=#{token}&type=#{type}&cond=#{cond}"
        rs   =get(ip, path, port)
      else
        url = "#{url}id=#{id}&token=#{token}&type=#{type}&cond=#{cond}"
        rs  = get(url)
      end
      if rs.nil?||rs.empty?
        puts "IAM Socket bugs!Return value format error!"
        rs = false
      else
        JSON.parse(rs)
      end
    end

    #用户登录-用户查询可用应用列表
    def usr_login_list_app_bytype(usr, pwd, cond, flag, type="name")
      rs   = user_login(usr, pwd)
      id   =rs["uid"]
      token=rs["access_token"]
      user_app_list_bytype(cond, id, token, flag, type)
    end

    #用户绑定应用
    # curl -X POST "http://192.168.10.9:8091/userApps?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=6442491a795e6bd5d700a81b24d336f4" -d '{"client_id":"160510579648"}'
    # data = {"client_id"=>"123"} 单个绑定
    # data = {"client_id"=>"123", "client_id"=>"234"} #批量绑定
    def usr_binding_app(token, uid, data, usr_url=USER_APP_URL)
      data = data.to_json
      url  = "#{usr_url}id=#{uid}&token=#{token}"
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #用户解绑应用
    # curl -X DELETE "http://192.168.10.9:8091/userApps?id=a7dff902-b80b-4cd7-9208-cdd856bddcd0&token=6442491a795e6bd5d700a81b24d336f4" -d '{"client_id":"160510579648"}'
    # data = {"client_id"=>"123"} 单个解绑
    # data = {"client_id"=>"123", "client_id"=>"234"} #批量解绑
    def usr_unbinding_app(token, uid, data, usr_url=USER_APP_URL)
      data = data.to_json
      url  = "#{usr_url}id=#{uid}&token=#{token}"
      http_del_data(url, data)
    end

    #用户查询应用-->用户绑定应用
    def qb_app(appname, usrid, token, flag=false, type="name")
      rs = user_app_list_bytype(appname, usrid, token, flag, type)
      # data = {"client_id"=>"123"} 单个绑定
      # data = {"client_id"=>"123", "client_id"=>"234"} #批量绑定
      unless rs["apps"].empty?
        data ={"client_id" => rs["apps"][0]["client_id"]}
        usr_binding_app(token, usrid, data)
      else
        puts "app'#{appname}' not exists!"
      end
    end

    #用户登录->用户查询应用-->用户绑定应用
    def usr_qb_app(usr, pwd, appname, flag=false, type="name")
      rs_login = user_login(usr, pwd)
      usrid    =rs_login["uid"]
      token    =rs_login["access_token"]
      qb_app(appname, usrid, token, flag, type)
    end

    #用户查询应用-->用户删除绑定
    def qub_app(appname, usrid, token, flag=false, type="name")
      rs = user_app_list_bytype(appname, usrid, token, flag, type)
      unless rs["apps"].empty?
        data ={"client_id" => rs["apps"][0]["client_id"]}
        usr_unbinding_app(token, usrid, data)
      else
        puts "app'#{appname}' not exists!"
      end
    end

    #用户登录->用户查询应用-->用户删除绑定
    def usr_qub_app(usr, pwd, appname, flag=false, type ="name")
      rs_login = user_login(usr, pwd)
      usrid    =rs_login["uid"]
      token    =rs_login["access_token"]
      qub_app(appname, usrid, token, flag, type)
    end

    # 查看用户详细信息
    # curl -X GET "http://192.168.10.9:8091/index.php/Users/detail?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&id=a7dff902-b80b-4cd7-9208-cdd856bddcd0"
    def get_user_details(admin_id, admin_token, uid, detail_url=USER_DETAIL_URL)
      url = "#{detail_url}admin_id=#{admin_id}&token=#{admin_token}&id=#{uid}"
      rs  = get(url)
      JSON.parse(rs)
    end

    #邮箱找回密码
    # curl -X POST http://192.168.10.9:8092/index.php/users/findPwdToken -d 'account=349160920@qq.com'
    def find_pwd_for_email(account, url=USER_FIND_PWD_URL)
      data = "account=#{account}"
      rs   = post_data(url, data)
      JSON.parse(rs) unless rs.empty?
    end

    #修改用户密码
    # curl -X POST http://192.168.10.9:8091/index.php/users/modPersonPwd -d 'oldpwd=123123&newpwd=321321&uid=123456&access_token=89aaa894cf9c8cf2c189ba8102d13d5d'
    def mofify_user_pwd(oldpwd, newpwd, uid, token, url=USER_MODPW_URL)
      data = "oldpwd=#{oldpwd}&newpwd=#{newpwd}&uid=#{uid}&access_token=#{token}"
      rs   = post_data(url, data)
      JSON.parse(rs) unless rs.empty?
    end

  end
end