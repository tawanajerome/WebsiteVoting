require 'dm-core'
require 'dm-migrations'
require 'bcrypt'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Voting
  include DataMapper::Resource
  property :id, Serial
  property :studentID, String
  property :vote, Integer
end

DataMapper.finalize()