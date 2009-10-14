require "spec_helper"
 
set :environment, :test
 
DataMapper::setup(:default, "sqlite3::memory:")
DataMapper.auto_migrate!
 
describe "Model" do
  
  before(:each) do
    Post.all.destroy!
  end
  
  it "should fail validation if Post have no title" do
    post = Post.new(:title => nil)
    
    post.should_not be_valid
    post.errors.should have_key(:title)
  end
  
  it "should save properly constructed Post" do
    post = Post.new(:title => "Blah", :body => "This is the body of the post. Yay!")
    
    post.should be_valid
    post.save.should be_true
    post.title.should == "Blah"
    post.body.should == "This is the body of the post. Yay!"
    post.created_at.should_not be_nil # FIXME: better date check
  end

end