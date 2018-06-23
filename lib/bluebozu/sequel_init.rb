require 'sequel'

DB = Sequel.sqlite
DB.create_table :posts do
  String :post_id, primary_key: true
  String :title
  String :content, text: true
  Date :date
  String :category
end
