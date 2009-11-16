require "dm-core"
require "dm-validations"
require "dm-timestamps"
require "rdiscount"

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
  
  def formatted_content
    RDiscount.new(content).to_html
  end

  def summary
    content = formatted_content
    heading_index = content.index("<h2>")
    heading_index ? content[0..heading_index - 1] : content
  end
end
