require 'dm-core'
require 'dm-migrations'
require 'data_mapper'
require 'bcrypt'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Login
  include DataMapper::Resource
  property :id, Serial
  property :username, String, :required=>true
  property :name, String
  property :password, String
  property :role, String
end

DataMapper.finalize()