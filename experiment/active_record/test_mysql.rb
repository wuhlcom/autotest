require 'active_record'
rs = ActiveRecord::Base.establish_connection(
    :adapter  => 'mysql2',
    :host     => '192.168.10.9',
    :port     => "10000",
    :database => 'IAMDB',
    :username => 'iam',
    :password => 'iam')
# p rs.class
ActiveRecord::Base.logger = Logger.new(File.open('d:/database.log', 'a'))
class Zl_user < ActiveRecord::Base
    # set_table_name "zl_user" deprased,ÒÑ·Ï³ý
    self.table_name = "zl_user"
end

# p Zl_user.all
# p "11111111111111111111111111111111"
user = Zl_user.find("3cda3685-6640-43d1-ab8c-621aa14f3759")
p user
p user.account
p user.passwd
p Zl_user.class