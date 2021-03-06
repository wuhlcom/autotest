#encoding:utf-8
#iam api maneger api
#管理员接口
#author:wuhongliang
#date:2016-07-21
file_path = File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
  module Manager
    include IAMAPI::PubSocket
    # {
    #     "result":1,
    #     "name":ADMIN_USR,
    #     "nickname":"\u552f\u4e00\u77e5\u8def\u8d85\u7ea7\u7ba1\u7406\u5458",
    #     "uid":"1",
    #     "role_code":"1",
    #     "token":"34d5aeb4b075ef65f6aa156f202127e4"
    # }
    # {
    #     "err_code": 10006,
    #     "err_msg": "帐号或密码错误"
    # }
    # curl -X POST http://192.168.10.9:8082/admins/dologin -d 'name=admin@zhilutec.com&password=123123'
    def data_manager_login(usr, pw)
      data = "name=#{usr}&password=#{pw}"
    end

    # result:
    #   {
    #   "result"=>1,
    #   "name"=>ADMIN_USR,
    #   "nickname"=>"\u77E5\u8DEF\u7BA1\u7406\u5458",
    #   "uid"=>"1",
    #   "role_code"=>"1", "
    #   token"=>"ef75b14c2fe47c09b2f3def7e53d1f32"
    #   }
    #返回管理员uid和token
    def manager_login(usr=ADMIN_USR, pw=ADMIN_PW, url=MANAGER_LOG_URL)
      data       = data_manager_login(usr, pw)
      rs         = post_data(url, data)
      admin_hash = JSON.parse(rs)
    end

    #curl -X POST http://192.168.10.9:8082/index.php/admins/add/uid/1/token/34d5aeb4b075ef65f6aa156f202127e4
    # -d 'account=chaoji@126.com&nickname=test_nickname&password=123123&role_code=2&comments=ttttttt&pid=1'
    def url_manager_add(token, uid=1, url=MANAGER_ADD_URL)
      url = "#{url}/uid/#{uid}/token/#{token}"
    end

    def data_manager_add(account, nickname, passwd, rcode="2", comments="autotest", pid=1)
      data = "account=#{account}&nickname=#{nickname}&password=#{passwd}&role_code=#{rcode}&comments=#{comments}&pid=#{pid}"
    end

    #curl -X POST http://192.168.10.9:8082/index.php/admins/add/uid/1/token/34d5aeb4b075ef65f6aa156f202127e4
    # -d 'account=chaoji@126.com&nickname=test_nickname&password=123123&role_code=2&comments=ttttttt&pid=1'
    def mana_add(token, account, nickname, passwd, rcode="2", comments="autotest", uid=1, pid=1)
      url  = url_manager_add(token, uid)
      data = data_manager_add(account, nickname, passwd, rcode, comments, pid)
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #管理员登录->添加下一级管理员
    #rcode,2-超级管理员，3-系统管理员,4-配置管理员，5-监视管理员
    #return,hash
    def manager_add(account, nickname, passwd, rcode="2", comments="autotest", admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_login = manager_login(admin_usr, admin_pw)
      token    = rs_login["token"]
      uid      = rs_login["uid"]
      mana_add(token, account, nickname, passwd, rcode, comments, uid, uid)
    end

    #如果管理员存在删除后重新添加，如果不存在则直接添加
    #查询账户是否存在-存在的话先删除再添加账户，不存在直接添加
    def manager_del_add(account, passwd, nickname, rcode="2", comments="autotest", admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_admin = manager_login(admin_usr, admin_pw)
      if rs_admin.has_key?("err_code")
        puts "manager:#{admin_usr} not exists!"
        return rs_admin
      end

      token    = rs_admin["token"]
      uid      = rs_admin["uid"]
      rs_mlist = get_manager_list_byname(account, token, uid)
      if rs_mlist==false||rs_mlist["res"].empty?
        mana_add(token, account, nickname, passwd, rcode, comments, uid, uid)
      else
        userid = rs_mlist["res"][0]["id"]
        delete_manager(userid, token)
        mana_add(token, account, nickname, passwd, rcode, comments, uid, uid)
      end
    end

    #查询管理员信息
    #显示所有
    # curl -X GET http://192.168.10.9:8082/index.php/admins/index/uid/1/token/34d5aeb4b075ef65f6aa156f202127e4
    #分页显示
    # curl -X GET http://192.168.10.9:8082/index.php/admins/index/uid/1/p/2/token/34d5aeb4b075ef65f6aa156f202127e4
    #按用户名查找
    # curl -X GET http://192.168.10.9:8082/index.php/admins/index/uid/1/name/dengfei/token/34d5aeb4b075ef65f6aa156f202127e4
    def get_manager_list_all(token, uid="1", url=MANAGER_INDEX_URL)
      url = "#{url}/uid/#{uid}/token/#{token}"
      rs  = get(url)
      JSON.parse(rs)
    end

    #返回结果为hash,name是支持模糊匹配的
    # {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    # "res"=>[{"id"=>"11", "name"=>"whltest2@zhilutec.com", "nickname"=>"whltest2",
    # "comments"=>"autotest", "title"=>"\u8D85\u7EA7\u7BA1\u7406\u5458"}]}
    def get_manager_list_byname(account, token, uid="1", flag=false, url=MANAGER_INDEX_URL, ip=IAM_HOST, port=IAM_PORT)
      rs=""
      if flag
        path = "/index.php/admins/index/uid/#{uid}/name/#{account}/token/#{token}"
        rs   =get(ip, path, port)
      else
        url = "#{url}/uid/#{uid}/name/#{account}/token/#{token}"
        rs  =get(url)
      end
      if rs.nil?||rs.empty?
        puts "IAM Socket bugs!Return value format error!"
        rs = false
      else
        JSON.parse(rs)
      end
    end

    #返回结果为hash,name是支持模糊匹配的
    # {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    # "res"=>[{"id"=>"11", "name"=>"whltest2@zhilutec.com", "nickname"=>"whltest2",
    # "comments"=>"autotest", "title"=>"\u8D85\u7EA7\u7BA1\u7406\u5458"}]}
    # flag,为ture表示支持中文参数
    def get_mlist_byname(account, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW, flag=false)
      rs    = manager_login(admin_usr, admin_pw)
      token = rs["token"]
      uid   = rs["uid"]
      get_manager_list_byname(account, token, uid, flag)
    end

    def get_mlist_all(admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs = manager_login(admin_usr, admin_pw)
      get_manager_list_all(rs["token"])
    end

    #删除管理员
    # curl -X GET http://192.168.10.9:8082/index.php/admins/del/uid/1/userid/123/token/f4f2fd3697a4b9f72368081765e5be67
    # 知路管理员admin@zhilutec.com的token和uid
    def delete_manager(userid, token, uid="1", url=MANAGER_DEL_URL)
      url = "#{url}/uid/#{uid}/userid/#{userid}/token/#{token}"
      rs  = get(url)
      JSON.parse(rs)
    end

    #name必须用完整管理员名
    def del_manager(name, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_del   = {}
      rs_login = manager_login(admin_usr, admin_pw)
      if rs_login.has_key?("err_code")
        puts "login failed,manager #{name} not exists!"
        return rs_login
      else
        uid   = rs_login["uid"]
        token = rs_login["token"]
      end
      rs = get_manager_list_byname(name, token, uid)
      if rs==false||rs["res"].empty?
        puts "#{name} is not exists!"
      else
        userid = rs["res"][0]["id"]
        rs_del = delete_manager(userid, token, uid)
      end
      return rs_del
    end

    # curl -X POST http://192.168.10.9:8082/index.php/Admins/modPersonPwd -d 'uid=11&oldpwd=123123&newpwd=654321&token=01e7cbf4fa19d6a7d0ed2b3622605686'
    # MANAGER_MODPW_URL     = "#{API_ADDR}index.php/Admins/modPersonPwd" #管理员修改自身密码
    def manager_modpw(oldpw, newpw, uid, token, url=MANAGER_MODPW_URL)
      data = "uid=#{uid}&oldpwd=#{oldpw}&newpwd=#{newpw}&token=#{token}"
      rs   = post_data(url, data)
      if rs.empty?
        puts "IAM SOCKET buff!"
        rs = false
      else
        JSON.parse(rs)
      end
    end

    #管理员登录->修改密码
    def mana_modpw(oldpw, newpw, usr) #管理员修改自身密码
      rs    = manager_login(usr, oldpw)
      uid   = rs["uid"]
      token = rs["token"]
      manager_modpw(oldpw, newpw, uid, token)
    end

    # 手机管理员密码修改
    # curl -X POST http://192.168.10.9:8082/index.php/Admins/modpwdByMobile -d 'name=13923791162&password=123123&code=1234'
    def data_manager_modpw_mobile(phone, pw, code)
      data = "name=#{phone}&password=#{pw}&code=#{code}"
    end

    def phone_manager_modpw(phone, pw, code, url=MANAGER_MODPW_MOB_URL)
      data =data_manager_modpw_mobile(phone, pw, code)
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #获取手机管理员验证码->修改密码
    #  {"result": 1}
    def manager_modpw_mobile(phone, pw, url=MANAGER_MODPW_MOB_URL)
      fail "phone number must be 11 size" if phone.to_s.size != 11
      rs_code = request_mobile_code(phone)
      phone_manager_modpw(phone, pw, rs_code["code"], url)
    end

    #手管理员不存在则添加管理员并修改密码，管理存在，直接修改密码
    #phone必须是有效的号码段手机号如134X，158X,如果是251X会失败
    def mobile_manager_modpw(phone, mod_pw, add_pw="123456", nickname="autotest", admin_usr=ADMIN_USR, admin_pw=ADMIN_PW, url=MANAGER_MODPW_MOB_URL)
      fail "phone number must be 11 size" if phone.to_s.size != 11
      rs_login = manager_login(admin_usr, admin_pw) #超级管理登录
      token    = rs_login["token"]
      uid      = rs_login["uid"]
      rs_mlist = get_manager_list_byname(phone, token, uid)
      if rs_mlist["res"].empty? #如果管理员不存在则先添加管理员
        puts "add phone manager #{phone}"
        rs_mana = mana_add(token, phone, nickname, add_pw)
        if rs_mana["result"]==1
          puts "modify phone manager #{phone} pw"
          rs = manager_modpw_mobile(phone, mod_pw, url)
        else
          rs={"err_msg" => "add manager failed"}
        end
      else #管理员存在直接修改管理员密码
        puts "modify phone manager #{phone} pw"
        rs = manager_modpw_mobile(phone, mod_pw, url)
      end
      return rs
    end

    # curl -X POST http://192.168.10.9:8082/index.php/admins/edit/uid/1/token/34d5aeb4b075ef65f6aa156f202127e4
    # -d 'id=11&nickname=abc&comments=111111'
    # uid,登录管理员uid
    # token,登录管理员token
    #args,{id"=>"xx","nickname"=>"xxx","comments"=>"xxx"}
    def edit_manager_info(uid, token, id, args, url=MANAGER_INFO_MOD_URL)
      args_arr = []
      url      ="#{url}/uid/#{uid}/token/#{token}"
      args.merge!({"id" => "#{id}"})
      args.each do |key, value|
        args_arr<<"#{key}=#{value}"
      end
      data=args_arr.join("&")
      rs  = post_data(url, data)
      JSON.parse(rs)
    end

    #管理员修改自身信息
    #管理员登录->修改管理员信息
    #account,待修改管理员
    #args,{"nickname"=>"xxx","comments"=>"xxx"}
    def edit_mana_info(args, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs    = manager_login(admin_usr, admin_pw)
      token = rs["token"]
      uid   = rs["uid"]
      edit_manager_info(uid, token, uid, args)
    end

    #管理员修改子管理员信息
    #管理员登录->查询子管理员ID和token->修改子管理员信息
    #account,待修改管理员
    #args,{"nickname"=>"xxx","comments"=>"xxx"}
    def edit_submana_info(account, args, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs      = manager_login(admin_usr, admin_pw)
      token   = rs["token"]
      uid     = rs["uid"]
      rs_mlist=get_manager_list_byname(account, token, uid)
      id      = rs_mlist["res"][0]["id"]
      edit_manager_info(uid, token, id, args)
    end

    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" // 查询全部
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&listRows=2&p=2" // 分页查询
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&type=name&cond=123" // 模糊查询
    #args
    # 1: {"listRows"=>"2","p"=>"2"}
    # 2: {"type"=>"name","cond"=>"IAM"}
    #    type,模糊查询类型，type类型有：name:应用名称 id:应用编号 provider:应用提供方
    #    cond, 模糊查询条件。为空则不进行模糊查询，type,cond条件无效则查询全部
    # args ={"admin_id"=>"1","token"=>"xxx",type=>"name",cond="SampleAPP"}
    # args为nil则使用查询查全部的方式查询
    def data_app_list(token, uid="1", args =nil)
      data    =""
      args_arr=[]
      if args.nil?
        data = "admin_id=#{uid}&token=#{token}"
      elsif args.kind_of?(Hash)
        data = "admin_id=#{uid}&token=#{token}&"
        args.each do |key, value|
          args_arr<<"#{key}=#{value}"
        end
        data=data+args_arr.join("&")
      else
        "params error!"
      end
      return data
    end

    #return,Hash，返回应用列表信息
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" // 查询全部
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&listRows=2&p=2" // 分页查询
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&type=name&cond=123" // 模糊查询
    # args ={"admin_id"=>"1","token"=>"xxx",type=>"name",cond="SampleAPP"}
    # return
    #{"totalRows":"10","listRows":"2","nowPage":1,"apps":
    # [{"client_id":"160425838887","client_secret":"OE05KsETOwY4y9W4zBPVtGTSUFzqRMf5",
    # "admin_id":"1","name":"123123","provider":"112323","redirect_uri":"safef","status":"0",
    # "comments":null,"expires_in":"1493111037","create_time":"1461575037","update_time":"1461575037"}]}
    # args为nil则使用查询查全部的方式查询
    def get_app_list(token, uid="1", args =nil, url=APP_URL)
      url = url+data_app_list(token, uid, args)
      rs  = get(url)
      JSON.parse(rs)
    end

    #return,Array，获取应用列表中应用信息
    # args ={"admin_id"=>"1","token"=>"xxx",type=>"name",cond="SampleAPP"}
    # args为nil则使用查询查全部的方式查询
    def get_app_info(token, uid="1", args =nil, url=APP_URL)
      rs = get_app_list(token, uid, args, url)
      rs["apps"]
    end

    #return,Hash，获取应用列表中指定应用信息
    # args ={"admin_id"=>"1","token"=>"xxx",type=>"name",cond="SampleAPP"}
    # args为nil则使用查询查全部的方式查询
    def get_spec_app_info(token, appname, uid="1", args =nil, url=APP_URL)
      app_info={}
      rs      = get_app_info(token, uid, args, url)
      rs.each do |app|
        if app.has_value?(appname)
          app_info=app
        end
      end
      return app_info
    end

    #创建应用
    # curl -X POST "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" -d '{"name":"test", "provider":"知路公司","redirect_uri":"http://www.test.com"}'
    #"{\"name\":\"name\", \"provider\":\"provider\",\"redirect_uri\":\"redirect_uri\",\"comments\":\"comments\"}"
    #args ={"name"=>"name", "provider"=>"provider", "redirect_uri"=>"redirect_uri", "comments"=>"comments"}
    def create_apply(admin_id, token, args, app_url=APP_URL)
      args = args.to_json
      url  = "#{app_url}admin_id=#{admin_id}&token=#{token}"
      rs   = post_data(url, args)
      JSON.parse(rs)
    end

    #管理员登录->创建应用->激活/禁用
    # args ={"name"=>"name", "provider"=>"provider", "redirect_uri"=>"redirect_uri", "comments"=>"comments"}
    def mana_create_app(args, usr=ADMIN_USR, pw=ADMIN_PW, app_url=APP_URL)
      rs       = manager_login(usr, pw)
      admin_id = rs["uid"]
      token    = rs["token"]
      create_apply(admin_id, token, args, app_url)
    end

    # 返回应用ID
    def get_client_id(apply_name, token, uid, args=nil, url=APP_URL)
      if apply_name.kind_of?(Array)
        client_id_arr = []
        apply_name.each do |apply|
          res = get_spec_app_info(token, apply, uid, args, url)
          client_id_arr << res["client_id"]
        end
        client_id_arr.join(",")
      else
        res = get_spec_app_info(token, apply_name, uid, args, url)
        res["client_id"]
      end
    end

    #删除指定应用
    # curl -X DELETE "http://192.168.10.9:8082/apps?id=160517254512&admin_id=1&token=125e0d6b0cf379e4d51fbf47bdd9598c"
    # curl -X DELETE "http://192.168.10.9:8082/apps?id=1111,2222,3333&admin_id=1" // 批量删除
    #appname = "autotest1"
    #appname = ["autotest1", "autotest2"]
    def del_apply(appname, token, uid, args =nil, url=APP_URL)
      client_id = get_client_id(appname, token, uid, args, url) #应用ID
      path      = "#{url}id=#{client_id}&admin_id=#{uid}&token=#{token}"
      rs        = http_del(path)
      JSON.parse(rs)
    end

    #管理登录->查询应用是否存在->存在则删除
    # args ={"admin_id"=>"1","token"=>"xxx",type=>"name",cond="SampleAPP"}
    def mana_del_app(appname, args=nil, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW, appurl=APP_URL)
      rs_login = manager_login(admin_usr, admin_pw)
      token    = rs_login["token"]
      uid      = rs_login["uid"]
      del_apply(appname, token, uid, args, appurl)
    end

    #查看应用详情
    # curl -X GET "http://192.168.10.9:8082/apps?id=160512231520&admin_id=1&token=34d5aeb4b075ef65f6aa156f202127e4"
    def apply_details(client_id, admin_id, token, app_url=APP_URL)
      url = "#{app_url}id=#{client_id}&admin_id=#{admin_id}&token=#{token}"
      rs  = http_get(url)
      JSON.parse(rs)
    end

    #登录管理员 -> 获取应用ID -> 查看应用详情
    def check_app_details(appname, args=nil, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_login     = manager_login(admin_usr, admin_pw)
      token        = rs_login["token"]
      uid          = rs_login["uid"]
      rs_client_id = get_client_id(appname, token, uid, args)
      apply_details(rs_client_id, uid, token)
    end

    #修改应用
    #curl -X PUT "http://192.168.10.9:8082/apps?admin_id=1&token=34d5aeb4b075ef65f6aa156f202127e4&id=160512231520" -d '{"name":"test_put","provider":"zhilu","redirect_uri":"http://www.zhilutec.com","comments":""}'
    #args,Hash
    # args = {"name"=> "name", "provider"=> "provider", "redirect_uri"=> "re_uri", "comments"=> "comments"}
    def modify_apply(admin_id, token, client_id, args, app_url=APP_URL)
      url = "#{app_url}admin_id=#{admin_id}&token=#{token}&id=#{client_id}"
      rs  = http_put(url, args.to_json)
      JSON.parse(rs)
    end

    #获取应用ID-修改应用ID
    def mod_app(old_appname, token, uid, args1, args=nil)
      rs_client_id = get_client_id(old_appname, token, uid, args)
      modify_apply(uid, token, rs_client_id, args1)
    end

    #管理员登录->获取应用ID-修改应用ID
    def mana_mod_app(old_appname, args1, args=nil, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_login = manager_login(admin_usr, admin_pw)
      token    = rs_login["token"]
      uid      = rs_login["uid"]
      mod_app(old_appname, token, uid, args1, args)
    end

    # curl -X PUT http://192.168.10.9:8082/apps/status?admin_id=1&token=xxxx -d '{"id":"160408322740,160408513385","status":"1"}'
    # args,两种格式
    # {"id"=>["160408322740","160408513385"], "status"=>"0"}
    # {"id"=>160408322740,160408513385", "status"=>"0"} #注意这里的多个id是以逗号隔开的字符串，status 1表示打开，0关闭,默认请使用0
    def active_app(args, admin_id, token, url=APP_ACTIVE_URL)
      url = "#{url}admin_id=#{admin_id}&token=#{token}"
      if args["id"].kind_of?(Array)
        ids       = args["id"].join(",")
        args["id"]=ids # 将hash格式转成这种:{"id"=>160408322740,160408513385", "status"=>"1"}
      end
      data = args.to_json
      rs   = http_put(url, data)
      JSON.parse(rs)
    end

    #apply_name可以是数组或字符串
    def get_client_active_app(appname, token, uid, status="0", args=nil)
      id      = get_client_id(appname, token, uid, args)
      app_args={"id" => id, "status" => status}
      active_app(app_args, uid, token)
    end

    #管理员登录->active应用
    def mana_active_app(appname, status, args=nil, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_login = manager_login(admin_usr, admin_pw)
      token    = rs_login["token"]
      uid      = rs_login["uid"]
      get_client_active_app(appname, token, uid, status, args)
    end

    #查询应用->应用不存在创建应用-->查询应用-->应用存在-->激活/禁用应用
    #查询应用->应用存在-->激活/禁用应用
    #appname应用名
    #token管理员token
    #uid管理员uid
    #status,1 激活,0，禁用
    #args,创建应用args
    # args ={"name"=>"name", "provider"=>"provider", "redirect_uri"=>"redirect_uri", "comments"=>"comments"}
    def qc_app(appname, token, uid, args, status="0")
      id = get_client_id(appname, token, uid)
      if id.nil?
        puts "creating app ..."
        rs = create_apply(uid, token, args)
        if status.to_s=="1"
          puts "activing the new app..."
          rs = get_client_active_app(appname, token, uid, status)
        end
        rs
      else
        puts "app existed..."
        app_args={"id" => id, "status" => status}
        if status.to_s=="1"
          puts "activing exidsted app..."
          active_app(app_args, uid, token)
        else
          puts "fobidding exidsted app..."
          active_app(app_args, uid, token)
        end
      end
    end

    #管理员登录-->查询应用->应用不存在创建应用-->查询应用-->应用存在-->激活/禁用应用
    #管理员登录-->查询应用->应用存在-->激活/禁用应用
    #appname应用名
    #token管理员token
    #uid管理员uid
    #status,1 激活,0，禁用
    #args,创建应用args
    # args ={"name"=>"name", "provider"=>"provider", "redirect_uri"=>"redirect_uri", "comments"=>"comments"}
    def qca_app(appname, args, status="0", admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs    = manager_login(admin_usr, admin_pw)
      uid   = rs["uid"]
      token = rs["token"]
      qc_app(appname, token, uid, args, status)
    end

    # curl -X POST http://192.168.10.9:8082/index.php/Admins/findPwdToken -d 'account=349160920@126.com'
    # return {"result"=>1, "token"=>"EJD3GSzw48vH3INrPIS0KQ5HIobsaE7e"}
    def get_em_token(account, url=MANAGER_EMTOKEN_URL)
      data = "account=#{account}"
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    # name=378433855@qq.com&token=TQgL9BGMJiKijNc80IA6htklO7ryHyc1&password=654321'
    # name=378433855@qq.com&token=k6eqHyldRrrWkKqjGCPfVxJ9FyP2ubjf&password=45678944
    #'name=895344033@qq.com&token=sD0vWtEDzZUMI5mS3BMh5zzUh3Faxemq&password=654321'
    def data_modpw_email(account, token, pw)
      data="name=#{account}&token=#{token}&password=#{pw}"
    end

    #curl -X POST http://192.168.10.9:8082/index.php/Admins/modpwd -d 'name=895344033@qq.com&token=sD0vWtEDzZUMI5mS3BMh5zzUh3Faxemq&password=654321'
    #{"result"=1}
    def modify_emmanager_pw(account, token, pw, url=MANAGER_MODPW_EM_URL)
      data = data_modpw_email(account, token, pw)
      rs   = post_data(url, data)
      JSON.parse(rs)
    end

    #获取toke->修改密码
    def modify_emailmana_pw(account, pw, emTokenUrl=MANAGER_EMTOKEN_URL, url=MANAGER_MODPW_EM_URL)
      rs   = get_em_token(account, emTokenUrl)
      token=rs["token"]
      modify_emmanager_pw(account, token, pw, url)
    end

    #如果管理员存在删除后重新添加，如果不存在则直接添加
    #查询账户是否存在-存在的话先删除再添加账户，不存在直接添加
    #添加完成用户再登录
    def manager_add_login(account, passwd, nickname, rcode="2", comments="autotest", admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      manager_del_add(account, passwd, nickname, rcode, comments, admin_usr, admin_pw)
      manager_login(account, passwd)
    end

    # curl -X GET "http://192.168.10.9:8091/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67" // 查询全部
    # curl -X GET "http://192.168.10.9:8091/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&listRows=3&p=2" // 分页查询
    # curl -X GET "http://192.168.10.9:8091/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&type=account&cond=test" // 模糊查询
    #args,hash,{"type"=>"account","cond"=>"xxx"}
    #args,hash,{"listRows"=>"3","p"=>"2"}
    def data_user_list(admin_id, token, args)
      data    =""
      args_arr=[]
      if args.nil?
        data = "admin_id=#{admin_id}&token=#{token}"
      elsif args.kind_of?(Hash)
        data = "admin_id=#{admin_id}&token=#{token}&"
        args.each do |key, value|
          args_arr<<"#{key}=#{value}"
        end
        data=data+args_arr.join("&")
      else
        "params error!"
      end
      return data
    end

    #return,Hash，返回用户列表信息
    # curl -X GET "http://192.168.10.9:8091/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67" // 查询全部
    # curl -X GET "http://192.168.10.9:8091/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&listRows=3&p=2" // 分页查询
    # curl -X GET "http://192.168.10.9:8091/users?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&type=account&cond=test" // 模糊查询
    #args,hash,{"type"=>"account","cond"=>"xxx"}
    #args,hash,{"listRows"=>"3","p"=>"2"}
    #return,hash
    #  {"totalRows"=>"1", "listRows"=>10, "nowPage"=>1,
    #   "users"=>[{"id"=>"498f62de-d807-4496-b4f0-a0215b365f56", "account"=>"13103158888", "name"=>nil, "
    #    sex"=>nil, "qq"=>nil, "create_time"=>"1471415585"}]}
    def get_user_list(admin_id, token, args=nil, app_url=USER_LIST_URL)
      url = app_url+data_user_list(admin_id, token, args)
      rs  = get(url)
      JSON.parse(rs) unless rs.empty?
    end

    # 查看用户详细信息
    # curl -X GET "http://192.168.10.9:8091/index.php/Users/detail?admin_id=1&token=f4f2fd3697a4b9f72368081765e5be67&id=a7dff902-b80b-4cd7-9208-cdd856bddcd0"
    def get_user_details(admin_id, admin_token, uid, detail_url=USER_DETAIL_URL)
      url = "#{detail_url}admin_id=#{admin_id}&token=#{admin_token}&id=#{uid}"
      rs  = get(url)
      JSON.parse(rs)
    end

    #return,Hash，返回应用列表信息, 可以使用中文查询
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=f816eabf9964b995313948a0d6c4c085" // 查询全部
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&listRows=2&p=2" // 分页查询
    # curl -X GET "http://192.168.10.9:8082/apps?admin_id=1&token=XXXX&type=name&cond=123" // 模糊查询
    def get_app_list_chinese(token, uid, args=nil, app_url=APP_URL)
      url  = app_url+data_app_list(token, uid, args)
      ip   = url.slice(/(\d+\.\d+\.\d+\.\d+)/, 1)
      port = url.slice(/\d+\.\d+\.\d+\.\d+:(\d+?)\//, 1)
      path = url.slice(/\d+\.\d+\.\d+\.\d+:\d+?(\/.+)/, 1)
      rs   = get(ip, path, port)
      JSON.parse(rs)
    end

    #管理员登录 -> 获取应用id
    def mana_get_client_id(appname, args=nil, admin_usr=ADMIN_USR, admin_pw=ADMIN_PW)
      rs_login = manager_login(admin_usr, admin_pw)
      token    = rs_login["token"]
      uid      = rs_login["uid"]
      get_client_id(appname, token, uid, args)
    end

    # curl -X DELETE "http://192.168.10.9:8082/appFiles?client_id=160517937222&file_name=xxx"
    #删除应用进程文件
    #client_id,应用id
    #file_name,进程文件
    def delete_app_file(client_id, file_name, url=APPFILES_URL)
      url="#{url}client_id=#{client_id}&file_name=#{file_name}"
      rs = http_del(url)
      JSON.parse(rs)
    end

    #获取应用id->删除应用进程文件
    def gd_app_file(apply_name, token, uid, file_name)
      client_id = get_client_id(apply_name, token, uid)
      delete_app_file(client_id, file_name)
    end

    #获取应用id->删除应用进程文件
    def mana_del_app_file(apply_name, file_name, usr=ADMIN_USR, pw=ADMIN_PW)
      rs   = manager_login(usr, pw)
      token=rs["token"]
      uid  =rs["uid"]
      gd_app_file(apply_name, token, uid, file_name)
    end

  end
end