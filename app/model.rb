# require "dm-core"
require "datamapper"

class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :nullable => false
  property :body, Text
  property :created_at, DateTime
  
  def trimmed_body
    return "#{body[0..999]}..." if body.size > 1000 
    body
  end
end
