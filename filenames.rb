require 'dm-core'
require 'dm-migrations'
require 'data_mapper'
require 'bcrypt'


DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Filenames
  include DataMapper::Resource
  property :id, Serial
  property :filename, String
  property :content, Text
end

DataMapper.finalize