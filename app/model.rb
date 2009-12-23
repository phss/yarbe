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
  property :link, String, :default => lambda { |r, p| r.title ? r.title.downcase.split.join("_") : "invalid_post" }
  property :content, Text, :nullable => false, :message => "Content is required"
  property :created_at, DateTime
  
  def formatted_content
    RDiscount.new(content).to_html
  end

  def summary
    summary_content = formatted_content
    summary_content = summary_content[0..summary_content.index("<h2>") - 1] if more?
    return summary_content
  end
  
  def more?
    formatted_content.include?("<h2>")
  end
  
end
