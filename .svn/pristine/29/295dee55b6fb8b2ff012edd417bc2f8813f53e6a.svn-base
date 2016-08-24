require 'active_record'
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'TestCase'
# ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => ":memory:")
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database  => File.dirname(__FILE__))
ActiveRecord::Schema.define do
  # drop_table :hosts if table_exists? :hosts
  create_table :test_cases do |table|
    table.column :name, :string
  end

  # drop_table :disks if table_exists? :disks
  # create_table :disks do |table|
  #   table.column :host_id, :integer
  #   table.column :dev_name, :string
  #   table.column :mnt_point, :string
  #   table.column :mb_available, :integer
  # end
  # # drop_table :reports if table_exists? :reports
  # create_table :reports do |table|
  #   table.column :disk_id, :integer
  #   table.column :created_at, :datetime
  #   table.column :mb_used, :integer
  # end
end