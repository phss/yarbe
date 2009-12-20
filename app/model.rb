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
  property :link, String
  property :content, Text, :nullable => false, :message => "Content is required"
  property :created_at, DateTime
  
  def initialize(hash = {})
    super(hash)
    self.link = title ? title.downcase.split.join("_") : "invalid_post"
  end
  
  def formatted_content
    RDiscount.new(content).to_html
  end

  def summary
    summary_content = formatted_content
    heading_index = summary_content.index("<h2>") 
    heading_index ? summary_content[0..heading_index - 1] + read_more_link : summary_content
  end
  
  private
  
  def read_more_link
    "<a href=\"post/#{link}\">Read more...</a>" # TODO: move this to the view
  end
end
