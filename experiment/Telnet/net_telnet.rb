require 'net/telnet'
# localhost = Net::Telnet::new("Host" => "192.168.100.1",
#                              "Timeout" => 10,
#                              "Waittime"=>1,
#                              "Prompt" => /[$%#>:] \z/n)
# localhost.login("admin", "admin") { |c| print c }
# localhost.cmd("free") { |c| print c }
# localhost.close

##########################Telnet Router##########
# ip = "192.168.100.1"
# usr="admin"
# pw = "admin"
# localhost = Net::Telnet::new("Host" => ip,
#                              "Timeout" => 10,
#                              "Waittime"=> 1,
#                              "Prompt" => /[$%#>:] \z/n)
# localhost.login(usr, pw) { |c| print c }
# ��string����ӻ��з���,���䷢�͵�Զ��������,���ȴ�Զ�����������һ����ʾmatch.
# match��Ĭ��ֵȡ����new��ָ����"Prompt". timeout��Ĭ��ֵȡ��new��ָ����"Timeout".
# ��������õĻ�, �������ַ��������������������п������.
# localhost.cmd("String"=>"top","Match"=>/CPU:/,"Timeout"=>2) { |c| print c }
#\cc==Ctrl+c
# quit = "quit"
# localhost.cmd(quit) { |c| print c }
# localhost.cmd("\cc") { |c| print c }
# localhost.close

