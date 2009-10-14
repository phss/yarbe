require "datamapper"

class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :nullable => false
  property :body, Text
  property :created_at, DateTime
end