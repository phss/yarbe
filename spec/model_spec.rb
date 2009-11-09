require "spec_helper"
 
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
  
  describe "(trimming body)" do
    it "should trim body to 1000 characters" do
      post = Post.new(:body => "0123456789" * 200)

      post.trimmed_body.should == ("0123456789") * 100 + "..."
    end

    it "should trim body to body size and content if it's less than 1000 characters" do
      post = Post.new(:body => "Small body")

      post.trimmed_body.should == "Small body"
    end
  end

end