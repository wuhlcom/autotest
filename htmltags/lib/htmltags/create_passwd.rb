#encoding:utf-8
# create wifi passwd config
# author : wuhongliang
# date   : 2015-6-05
require "rexml/document"

module HtmlTag
		class Passwd
				COMMENT = '<?xml version="1.0"?>'
				attr_accessor :doc, :root_el

				def initialize()
						@doc     = REXML::Document.new #创建XML内容
						@root_el = @doc.add_element("WLANProfile")
				end

				# Evaluates to: this Element
				#  a = Element.new("a")
				#  a.add_namespace("xmlns:foo", "bar" )
				#  a.add_namespace("foo", "bar")  # shorthand for previous line
				#  a.add_namespace("twiddle")
				#  puts a   #-> <a xmlns:foo='bar' xmlns='twiddle'/>
				def add_ns(uri="http://www.microsoft.com/networking/WLAN/profile/v1")
						@root_el.add_namespace(uri)
				end

				def root_add_el(el_name)
						@root_el.add_element(el_name)
				end

				def add_el(el, el_name)
						el.add_element(el_name)
				end

				def add_txt(el, txt)
						el.add_text(txt)
				end

				def add_name(ssid_name, el_name="name")
						element = root_add_el(el_name)
						add_txt(element, ssid_name)
						@doc
				end

				# <SSIDConfig>
				# <SSID>
				#   <hex>7775686f6e676c69616e67</hex>
				#   <name>wuhongliang</name>
				# </SSID>
				# </SSIDConfig>
				def add_ssidconfig(ssid_name, el_name="SSIDConfig")
						hex          = ssid_name.unpack("H*")[0]
						element      = root_add_el(el_name)
						ssid_element = add_el(element, "SSID")

						hex_el = add_el(ssid_element, "hex")
						add_txt(hex_el, hex)

						name_el = add_el(ssid_element, "name")
						add_txt(name_el, ssid_name)
						@doc
				end

				# <connectionType>ESS</connectionType>
				def add_connection_type(el_name="connectionType", type="ESS")
						element = root_add_el(el_name)
						add_txt(element, type)
						@doc
				end

				# <connectionMode>auto</connectionMode>
				def add_connection_mode(el_name="connectionMode", mode="auto")
						element = root_add_el(el_name)
						add_txt(element, mode)
						@doc
				end

				#   <MSM>
				#   <security>
				#   <authEncryption>
				#   <authentication>WPA2PSK</authentication>
				# <encryption>AES</encryption>
				#   <useOneX>false</useOneX>
				#  </authEncryption>
				#   <sharedKey>
				#   <keyType>passPhrase</keyType>
				# <protected>false</protected>
				#   <keyMaterial>1234567890</keyMaterial>
				#  </sharedKey>
				#   </security>
				# </MSM>
				def add_aes_msm(au_type, pass_type, passwd="12345678", el_name="MSM")
						pass_type   = "AES" if pass_type == "CCMP"
						msm         = root_add_el(el_name)
						security_el = add_el(msm, "security")

						authEncryption_el = add_el(security_el, "authEncryption")

						authentication_el = add_el(authEncryption_el, "authentication")
						add_txt(authentication_el, au_type)
						encryption_el = add_el(authEncryption_el, "encryption")
						add_txt(encryption_el, pass_type)
						useOneX_el = add_el(authEncryption_el, "useOneX")
						add_txt(useOneX_el, "false")

						sharedKey_el = add_el(security_el, "sharedKey")

						keyType_el = add_el(sharedKey_el, "keyType")
						add_txt(keyType_el, "passPhrase")
						protected_el = add_el(sharedKey_el, "protected")
						add_txt(protected_el, "false")
						keyMaterial_el = add_el(sharedKey_el, "keyMaterial")
						add_txt(keyMaterial_el, passwd)
						@doc
				end

				#DLINK DIR-816硬件版本A1用WAP2-个人使用TKIP加密算法
				def add_tkip_msm_dlink(au_type, pass_type, passwd="12345678", el_name="MSM")
						pass_type   = "TKIP" if pass_type == "CCMP"
						msm         = root_add_el(el_name)
						security_el = add_el(msm, "security")

						authEncryption_el = add_el(security_el, "authEncryption")

						authentication_el = add_el(authEncryption_el, "authentication")
						add_txt(authentication_el, au_type)
						encryption_el = add_el(authEncryption_el, "encryption")
						add_txt(encryption_el, pass_type)
						useOneX_el = add_el(authEncryption_el, "useOneX")
						add_txt(useOneX_el, "false")

						sharedKey_el = add_el(security_el, "sharedKey")

						keyType_el = add_el(sharedKey_el, "keyType")
						add_txt(keyType_el, "passPhrase")
						protected_el = add_el(sharedKey_el, "protected")
						add_txt(protected_el, "false")
						keyMaterial_el = add_el(sharedKey_el, "keyMaterial")
						add_txt(keyMaterial_el, passwd)
						@doc
				end

				#  <MSM>
				#  <security>
				#  <authEncryption>
				#       <authentication>open</authentication>
				# 			<encryption>none</encryption>
				#      <useOneX>false</useOneX>
				# </authEncryption>
				#  </security>
				# </MSM>
				def add_none_msm(el_name="MSM")
						msm         = root_add_el(el_name)
						security_el = add_el(msm, "security")

						authEncryption_el = add_el(security_el, "authEncryption")

						authentication_el = add_el(authEncryption_el, "authentication")
						add_txt(authentication_el, "open")
						encryption_el = add_el(authEncryption_el, "encryption")
						add_txt(encryption_el, "none")
						useOneX_el = add_el(authEncryption_el, "useOneX")
						add_txt(useOneX_el, "false")
						@doc
				end

				def create_aes(args)
						args[:passwd]= "12345678" if args[:passwd].nil?
						passwd       = args[:passwd]
						ssid_name    =args[:ssid]
						au_type      = args[:au_type]
						pass_type    = args[:pass_type]
						raise "ssid name error" if ssid_name.nil?||ssid_name==""
						file_path=args[:file_path]
						raise "file_path error" if file_path.nil?||file_path==""
						add_ns
						add_name(ssid_name)
						add_ssidconfig(ssid_name)
						add_connection_type()
						add_connection_mode()
						add_aes_msm(au_type, pass_type, passwd)
						save_xml(file_path)
				end

				#创建TKIP密码
				def create_tkip_dlink(args)
						args[:passwd]= "12345678" if args[:passwd].nil?
						passwd       = args[:passwd]
						ssid_name    =args[:ssid]
						au_type      = args[:au_type]
						pass_type    = args[:pass_type]
						raise "ssid name error" if ssid_name.nil?||ssid_name==""
						file_path=args[:file_path]
						raise "file_path error" if file_path.nil?||file_path==""
						add_ns
						add_name(ssid_name)
						add_ssidconfig(ssid_name)
						add_connection_type()
						add_connection_mode()
						add_tkip_msm_dlink(au_type, pass_type, passwd)
						save_xml(file_path)
				end

				def create_none(args)
						ssid_name=args[:ssid]
						raise "ssid name error" if ssid_name.nil?||ssid_name==""
						file_path=args[:file_path]
						raise "file_path error" if file_path.nil?||file_path==""
						add_ns
						add_name(ssid_name)
						add_ssidconfig(ssid_name)
						add_connection_type()
						add_connection_mode()
						add_none_msm
						save_xml(file_path)
				end

				def save_xml(file_path)
						open(file_path, "w") { |file|
								file.puts COMMENT
								file.puts @doc.write()
						}
				end
		end
end

if $0==__FILE__
		nicname    ="Wireless"
		ssid_name  ="wuhongliang"
		passwd     ="1234567890"
		passwd_xml = "#{nicname}-#{ssid_name}.xml"
		args       ={
				:ssid      => ssid_name,
				:passwd    => passwd,
				:file_path => passwd_xml
		}
		doc        = REXML::Document.new #创建XML内容
		o          =HtmlTag::Passwd.new()

		# p o.doc.object_id
		# puts o.add_name(ssid_name)
		# puts o.add_ssidconfig(ssid_name)
		#  puts o.add_connection_type()
		#  puts o.add_connection_mode()
		# puts o.create_aes(args)

		puts o.create_none(args)
		o.doc     = REXML::Document.new #创建XML内容
		o.root_el = o.doc.add_element("WLANProfile")

		puts o.create_aes(args)
end