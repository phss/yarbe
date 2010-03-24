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
  
  def title=(new_title)
    attribute_set(:title, new_title)
    attribute_set(:link, link_for(new_title)) if new_title
  end
  
  def formatted_content
    RDiscount.new(content).to_html
  end

  def summary
    summary_content = formatted_content
    summary_content = summary_content[0..summary_content.index("<h2") - 1] if more?
    return summary_content
  end
  
  def more?
    formatted_content.include?("<h2")
  end
  
  def self.all_for_display
    Post.all(:order => [ :created_at.desc ])
  end
  
  private
  
  def link_for(title)
    title.downcase.gsub(/[^\w\s]/,"").split.join("_")
  end
  
end
