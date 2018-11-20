require 'dm-core'
require 'dm-migrations'
require 'data_mapper'
require 'bcrypt'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Login
  include DataMapper::Resource
  property :username, String, :key=>true
  property :name, String
  property :password, Text
  property :role, String
end
DataMapper.finalize()






