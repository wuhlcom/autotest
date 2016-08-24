#encoding:utf-8
#iam api device api
#用户接口
#author:liluping
#date:2016-07-21
file_path = File.expand_path('../pubsocket', __FILE__)
require file_path
module IAMAPI
    module Device
        include IAMAPI::PubSocket

        #用户添加设备
        # curl -X POST "http://192.168.10.9:8092/userDevices" -d "name=dev1&mac=aa:aa:aa:aa:aa:bb&userid=ff6c5df6-d6c9-45b1-9890-ccb9bc56de4b"
        def add_device(dev_name, dev_mac, uid, url=USER_DEVICES_URL)
            data = "name=#{dev_name}&mac=#{dev_mac}&userid=#{uid}"
            rs   = post_data(url, data)
            JSON.parse(rs)
        end

        #用户删除设备
        # curl -X DELETE "http://192.168.10.9:8092/userDevices?user_id=ff6c5df6-d6c9-45b1-9890-ccb9bc56de4b&device_id=abuLqIfy"
        def delete_device(uid, dev_id, dev_url=USER_DEVICES_URL)
            url = "#{dev_url}?user_id=#{uid}&device_id=#{dev_id}"
            rs  = http_del(url)
            JSON.parse(rs)
        end

        def data_dev_list(uid, args)
            data    = ""
            args_arr=[]
            if args.nil?
                data = "user_id=#{uid}"
            elsif args.kind_of?(Hash)
                data = "user_id=#{uid}&"
                args.each do |key, value|
                    args_arr << "#{key}=#{value}"
                end
                data=data+args_arr.join("&")
            else
                "params error!"
            end
            data
        end

        #用户查看设备列表
        # uid //用户ID
        # curl -X GET "http://192.168.10.9:8082/userDevices?user_id=bf560602-4e33-46cd-b6b0-19200dc46721" // 查询全部
        # curl -X GET "http://192.168.10.9:8082/userDevices?user_id=3653bc7c-98ca-4c07-928c-a256507bbb45&listRows=3&p=0&type=name&cond=test" // 模糊查询
        def get_dev_list(uid, args=nil, dev_url=USER_DEVICES_URL)
            url = "#{dev_url}?"+data_dev_list(uid, args)
            rs  = get(url)
            JSON.parse(rs)
        end

        #return,Array，获取设备列表中设备信息
        def get_dev_info(uid, args =nil, url=USER_DEVICES_URL)
            rs = get_dev_list(uid, args, url)
            rs["resList"]
        end

        #return,Hash，获取设备列表中指定设备信息
        def get_spec_dev_info(devname, uid, args =nil, url=USER_DEVICES_URL)
            dev_info={}
            rs      = get_dev_info(uid, args, url)
            rs.each do |dev|
                if dev.has_value?(devname)
                    dev_info=dev
                end
            end
            dev_info
        end

        # 根据设备名返回设备ID
        def get_dev_id_for_name(dev_name, uid, args=nil, url=USER_DEVICES_URL)
            if dev_name.kind_of?(Array)
                dev_id_arr = []
                dev_name.each do |dev|
                    res = get_spec_dev_info(dev, uid, args, url)
                    dev_id_arr << res["device_id"]
                end
                dev_id_arr.join(",")
            else
                res = get_spec_dev_info(dev_name, uid, args, url)
                res["device_id"]
            end
        end

        # 根据设备mac返回设备ID
        # curl -X GET "http://192.168.10.165:81/cloudac/index.php/service/getDeviceID?mac=00:08:D2:00:3A:27"
        # curl -X GET "http://192.168.10.165:81/cloudac/index.php/service/getDeviceID?mac=23345"
        def get_dev_id_for_mac(dev_mac, dev_url=DEVICE_ID_URL)
            url = "#{dev_url}mac=#{dev_mac}"
            rs = get(url)
            JSON.parse(rs)["device_id"]
        end

        #设备关联应用
        # curl "http://192.168.10.9:8082/deviceApps/binding" -d '{"device_id":"c236411f466e09f0","client_id":["160602199227", "160602199227"]}'
        # curl "http://192.168.10.9:8082/deviceApps/binding" -d '{"device_id":"c236411f466e09f0","client_id":[]}'
        # data = "{\"device_id\":\"c236411f466e09f0\",\"client_id\":[\"160602199227\", \"160602199227\"]}"
        def dev_binding_apply(data, url=DEVICES_APP_BINDING_URL)
            post_data(url, data)
        end











    end
end
