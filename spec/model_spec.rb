require "spec_helper"
 
describe "Model" do
  
  before(:each) do
    Post.all.destroy!
  end
  
  it "should fail validation if Post have no title" do
    post = Post.new(:title => nil)
    
    post.should_not be_valid
    post.errors.should have_key(:title)
    post.errors[:title].should == ["Title is required"]
  end
  
  it "should fail validation if Post title is not unique" do
    Post.new(:title => "some title", :content => "first post").save
    post = Post.new(:title => "some title", :content => "second post")
    
    post.should_not be_valid
    post.errors.should have_key(:title)
    post.errors[:title].should == ["Title must be unique"]
  end
  
  it "should fail validation if Post have no content" do
    post = Post.new(:title => "Some title")
    
    post.should_not be_valid
    post.errors.should have_key(:content)
    post.errors[:content].should == ["Content is required"]
  end
  
  it "should save properly constructed Post" do
    post = Post.new(:title => "Blah", :content => "This is the content of the post. Yay!")
    
    post.should be_valid
    post.save.should be_true
    post.title.should == "Blah"
    post.content.should == "This is the content of the post. Yay!"
    post.created_at.should_not be_nil # FIXME: better date check
  end
  
  describe "(blurb)" do
    it "should have blurb as the first 1000 characters of the content" do
      post = Post.new(:content => "0123456789" * 200)

      post.blurb.should == ("0123456789") * 100 + "..."
    end

    it "should have blurb as the content if it's less than 1000 characters" do
      post = Post.new(:content => "Small content")

      post.blurb.should == "Small content"
    end
  end

end