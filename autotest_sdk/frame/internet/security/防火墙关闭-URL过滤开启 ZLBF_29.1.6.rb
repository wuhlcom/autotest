#
# description:
# author:liluping
# date:2015-09-23
# modify:
#
    testcase{
      attr = {"id"=>"ZLBF_29.1.6", "level"=>"P2", "auto"=>"n"}
    def prepare
      DRb.start_service
      @tc_dumpcap_pc2 = DRbObject.new_with_uri(@ts_drb_pc2)
      @tc_wait_time                           = 3
      @tag_usr_id                             = 'admuser'
      @tag_pw_id                              = 'admpass'

      @tc_tag_fw_button                       = "switch1"
      @tc_tag_url_button                      = "switch4"
      @tc_tag_button_switch_off               = "off"
      @tc_tag_button_switch_on                = "on"

      @tc_tag_options                         = "options"
      @tc_tag_secseting                       = "securitysetting"
      @tc_tag_select_text                     = "b_w_url"
      @tc_tag_url_setting                     = "menu_set"
      @tc_tag_select                          = "b_w_select"
      @tc_tag_select_add_btn                  = "add_btn"
      @tc_tag_save_button                     = "save_btn"
      @tc_tag_fw_seting                       = "Firewall-Settings"
      @tc_tag_select_black                    = "opa"
      @tc_tag_select_white                    = "opb"
      @tc_intset_list                         = "intset_list"
      @tc_intset_list_black                   = "black"
      @tc_intset_list_white                   = "white"
      @tc_intset_list_cls                     = "text"

      @tc_tag_url_baidu                       = "www.baidu.com"
      @tc_tag_url_sohu                        = "www.sohu.com"
      @tc_tag_link_error                      = "errorTitleText"

      @ssid_pwd                               = "12345678"
      @tc_net_status                          = "setstatus"
      @tc_dut_wifi_ssid     = "ssid"
      @tc_dut_wifi_ssid_pwd = "input_password1"
    end

    def process

      operate("1�����뵽����ǽ���棬������ǽ�ܿ��عرգ�URL���˿��������棻") {
        @browser.span(id: @ts_tag_lan).wait_until_present(@tc_wait_time) #�ȴ�2s
        @browser.span(id: @ts_tag_lan).click

        @lan_iframe = @browser.iframe(src: @ts_tag_lan_src)
        assert(@lan_iframe.exists?, "����������ʧ�ܣ�")
        p "��ȡDUT��ssid".to_gbk
        @dut_ssid = @lan_iframe.text_field(id: @tc_dut_wifi_ssid).value
        p "DUTssid --> #{@dut_ssid}".to_gbk
        @dut_ssid_pwd = @lan_iframe.text_field(id: @tc_dut_wifi_ssid_pwd).value
        p "DUTssid_pwd --> #{@dut_ssid_pwd}".to_gbk
        if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
          @browser.execute_script(@ts_close_div)
        end

        #pc2����dut����
        p "PC2����wifi".to_gbk
        flag ="1"
        rs   = @tc_dumpcap_pc2.connect(@dut_ssid, flag, @dut_ssid_pwd, @ts_wlan_nicname)
        assert(rs, "PC2 wifi����ʧ��".to_gbk)

        puts "����߼�ѡ�����".to_gbk
        # @browser.span(id: @tc_tag_options).wait_until_present(@tc_wait_time)
        @browser.link(id: @tc_tag_options).click
        @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
        assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
        option_link = @option_iframe.link(id: @tc_tag_secseting)
        option_link_state = option_link.attribute_value(:checked)
        unless option_link_state == "true"
          option_link.click
        end

        puts "�������ǽѡ��".to_gbk
        @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
        option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
        option_fw_iframe.click

        sleep @tc_wait_time
        puts "�رշ���ǽ�ܿ��ز���URL���˿���".to_gbk
        btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button,class_name: @tc_tag_button_switch_on)
        if btn_fw_on.exists?
          btn_fw_on.click
        end
        btn_url_off = @option_iframe.button(id: @tc_tag_url_button,class_name: @tc_tag_button_switch_off)
        if btn_url_off.exists?
          btn_url_off.click
        end
        @option_iframe.button(id: @tc_tag_save_button).click #����
      }

      operate("2������URL���˽�����Ӻ����������www.baidu.com�Ĺ���PC1��PC2�ܷ����www.baidu.com��������վ��") {
        puts "����URL����ѡ��".to_gbk
        @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
        option_url_iframe =  @option_iframe.link(id: @tc_tag_url_setting)
        option_url_iframe.click

        puts "��ӹ��˹ؼ���".to_gbk
        select_click = @option_iframe.select_list(id: @tc_tag_select)
        select_click.select("������")
        #�������������
        if !@option_iframe.span(text: @tc_tag_url_baidu).exists?
          @option_iframe.text_field(id: @tc_tag_select_text).set(@tc_tag_url_baidu)
          @option_iframe.link(class_name: @tc_tag_select_add_btn).click

          assert_equal(@option_iframe.div(id: "black").text, @tc_tag_url_baidu, "error-->��ӹؼ���#{@tc_tag_url_baidu}���ɹ���")
          @option_iframe.button(id: @tc_tag_save_button).click
        end

        if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
          @browser.execute_script(@ts_close_div)
        end

        puts "��֤PC1��PC2�ܷ��������".to_gbk
        response = send_http_request(@tc_tag_url_baidu)
        assert(response, "�����Է���#{@tc_tag_url_baidu}".to_gbk)

        response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
        assert(response, "�����Է���#{@tc_tag_url_baidu}".to_gbk)

        response = send_http_request(@tc_tag_url_sohu)
        assert(response, "�����Է���#{@tc_tag_url_sohu}".to_gbk)

        response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sohu)
        assert(response, "�����Է���#{@tc_tag_url_sohu}".to_gbk)
      }

      operate("3�������þͰ����������www.sohu.com�Ĺ���PC1��PC2�ܷ����www.sohu.com��������վ��") {
        #�ٴε�¼·����
        @browser.goto(@default_url)
        @browser.text_field(name:  @ts_tag_usr).set(@ts_default_usr)
        @browser.text_field(name:  @ts_tag_pw).set(@ts_default_pw)
        @browser.button(id: @ts_tag_sbm).click

        puts "����߼�ѡ�����".to_gbk
        # @browser.span(id: @tc_tag_options).wait_until_present(@tc_wait_time)
        @browser.link(id: @tc_tag_options).click
        @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
        assert(@option_iframe.exists?, "�򿪸߼�����ʧ�ܣ�")
        option_link = @option_iframe.link(id: @tc_tag_secseting)
        option_link_state = option_link.attribute_value(:checked)
        unless option_link_state == "true"
          option_link.click
        end

        puts "����URL����ѡ��".to_gbk
        @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
        option_url_iframe =  @option_iframe.link(id: @tc_tag_url_setting)
        option_url_iframe.click

        puts "��ӹ��˹ؼ���".to_gbk
        select_click = @option_iframe.select_list(id: @tc_tag_select)
        select_click.select("������")
        #�������������
        if !@option_iframe.span(text: @tc_tag_url_sohu).exists?
          @option_iframe.text_field(id: @tc_tag_select_text).set(@tc_tag_url_sohu)
          @option_iframe.link(class_name: @tc_tag_select_add_btn).click

          assert_equal(@option_iframe.div(id: "white").text, @tc_tag_url_sohu, "error-->��ӹؼ���#{@tc_tag_url_sohu}���ɹ���")
          @option_iframe.button(id: @tc_tag_save_button).click
        end

        if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
          @browser.execute_script(@ts_close_div)
        end

        puts "��֤PC1��PC2�ܷ��������".to_gbk
        response = send_http_request(@tc_tag_url_baidu)
        assert(response, "�����Է���#{@tc_tag_url_baidu}".to_gbk)

        response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_baidu)
        assert(response, "�����Է���#{@tc_tag_url_baidu}".to_gbk)

        response = send_http_request(@tc_tag_url_sohu)
        assert(response, "�����Է���#{@tc_tag_url_sohu}".to_gbk)

        response = @tc_dumpcap_pc2.send_http_request(@tc_tag_url_sohu)
        assert(response, "�����Է���#{@tc_tag_url_sohu}".to_gbk)
      }



    end

    def clearup
      operate("1 �رշ���ǽ�ܿ��غ�URL���˿���") {
        p "�Ͽ�wifi����".to_gbk
        @tc_dumpcap_pc2.netsh_disc_all #�Ͽ�wifi����
        sleep @tc_wait_time
        @browser.goto(@default_url)
        @browser.text_field(name:  @ts_tag_usr).set(@ts_default_usr)
        @browser.text_field(name:  @ts_tag_pw).set(@ts_default_pw)
        @browser.button(id: @ts_tag_sbm).click

        @browser.link(id: @ts_tag_options).wait_until_present(@tc_wait_time)
        @browser.link(id: @ts_tag_options).click

        @option_iframe = @browser.iframe(src: @ts_tag_advance_src)
        option_link = @option_iframe.link(id: @tc_tag_secseting)
        option_link_state = option_link.attribute_value(:checked)
        unless option_link_state == "true"
          option_link.click
        end

        @option_iframe.link(id: @tc_tag_fw_seting).wait_until_present(@tc_wait_time)
        option_fw_iframe = @option_iframe.link(id: @tc_tag_fw_seting)
        option_fw_iframe.click

        sleep @tc_wait_time
        puts "�رշ���ǽ�ܿ��غ�URL���˿���".to_gbk
        btn_fw_on = @option_iframe.button(id: @tc_tag_fw_button,class_name: @tc_tag_button_switch_on)

        if btn_fw_on.exists?
          btn_fw_on.click
        end
        btn_url_on = @option_iframe.button(id: @tc_tag_url_button,class_name: @tc_tag_button_switch_on)
        if btn_url_on.exists?
          btn_url_on.click
        end

        @option_iframe.button(id: @tc_tag_save_button).click

      }

      operate("3 ����������Ͱ�����") {

        @option_iframe.link(id: @tc_tag_url_setting).wait_until_present(@tc_wait_time)
        option_url_iframe =  @option_iframe.link(id: @tc_tag_url_setting)
        option_url_iframe.click

        @option_iframe.select_list(id: @tc_tag_select).click
        @option_iframe.option(id: @tc_tag_select_black).click

        black_url_str = @option_iframe.div(id: @tc_intset_list_black,class_name: @tc_intset_list).text
        black_url_arr = black_url_str.split("\n")
        if !black_url_arr.empty?
          #��Ҫģ������ƶ�������Ŀ��(�ڸ���Ŀ�����������)������ʵʩɾ������
          black_url_arr.each do |url|
            puts "ɾ��������#{url}".to_gbk
            @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
            sleep 1
            @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete").click
            sleep 2
          end
          @option_iframe.button(id: @tc_tag_save_button).click
        end

        sleep 5
        # @option_iframe.div(class_name: @ts_tag_net_reset_tip).wait_while_present(5) #�ȴ�������ʧ
        @option_iframe.select_list(id: @tc_tag_select).click
        @option_iframe.option(id: @tc_tag_select_white).click
        sleep 2
        # p @option_iframe.div(id: "white",class_name: @tc_intset_list).text
        white_url_str = @option_iframe.div(id: @tc_intset_list_white,class_name: @tc_intset_list).text
        white_url_arr = white_url_str.split("\n")
        if !white_url_arr.empty?
          white_url_arr.each do |url|
            puts "ɾ��������#{url}".to_gbk
            #��Ҫģ������ƶ�������Ŀ��(�ڸ���Ŀ�����������)������ʵʩɾ������
            @option_iframe.span(text: url, class_name: @tc_intset_list_cls).click
            sleep 1
            @option_iframe.span(text: url, class_name: @tc_intset_list_cls).parent.link(class_name: "delete").click
            sleep 2
          end
          @option_iframe.button(id: @tc_tag_save_button).click
        end

        if @browser.div(class_name: @ts_aui_state_focus).exists? || @browser.div(class_name: @ts_aui_state).exists?
          @browser.execute_script(@ts_close_div)
        end
      }
    end

    }
