# require "dm-core"
# require "dm-validations"
require "datamapper"

class Post
  include DataMapper::Resource
  
  property :id, Serial
  property :title, String, :nullable => false, :unique => true, 
                           :messages => {
                              :presence  => "Title is required",
                              :is_unique => "Title must be unique"
                           }
  property :content, Text, :nullable => false, :message => "Content is required"
  property :created_at, DateTime
  
  def blurb
    content.size > 1000 ? "#{content[0..999]}..."  : content
  end
end
