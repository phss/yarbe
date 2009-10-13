require "spec_helper"

set :environment, :test

DataMapper::setup(:default, "sqlite3::memory:")
DataMapper.auto_migrate!

describe Post do

  it "should do stuff" do
    post = Post.new
    post.should_not be_valid
    
    post.title = "Blah"
    post.should be_valid    
    post.save
  end
  
  it "should not clear the db" do
    Post.first.title.should == "Blah"
  end
  
  it "should clear db" do
    Post.all.destroy!
  end

end