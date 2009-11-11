# require "dm-core"
require "datamapper"

class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :nullable => false, :message => "Title is required"
  property :body, Text, :nullable => false, :message => "Content is required"
  property :created_at, DateTime
  
  def blurb
    body.size > 1000 ? "#{body[0..999]}..."  : body
  end
end
