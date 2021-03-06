require 'dm-core'
require 'dm-migrations'
require 'data_mapper'
require 'bcrypt'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Voting
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :first, String
  property :second, String
  property :third, String
end

DataMapper.finalize