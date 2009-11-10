# require "dm-core"
require "datamapper"

class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :nullable => false
  property :body, Text
  property :created_at, DateTime
  
  def blurb
    body.size > 1000 ? "#{body[0..999]}..."  : body
  end
end
