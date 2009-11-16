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
  
  def blurb
    content.size > 1000 ? "#{content[0..999]}..."  : content
  end

  def formatted_content
    RDiscount.new(content).to_html
  end

  def summary
    content = formatted_content
    content[0..content.index("<h") - 1]
  end
end
