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

  describe "(formatting)" do
    it "should allow markdown formatting in the content"  do
      markdown_content = <<eos
This is a heading
-----------------

This is a [link][l]

[l]: http://link
eos
      post = Post.new(:content => markdown_content)

      post.formatted_content.should == "<h2>This is a heading</h2>\n\n<p>This is a <a href=\"http://link\">link</a></p>\n"
    end

    it "should display the content until the first heading as summary" do
       markdown_content = <<eos
The summary goes from __here__ until...

...the start of a heading.

This is the end of the summary
-----------------

This should not appear
eos
      post = Post.new(:content => markdown_content)
      
      post.summary.should == "<p>The summary goes from <strong>here</strong> until...</p>\n\n<p>...the start of a heading.</p>\n\n"
    end

    it "should show whole post as summary in case there is no headings" do
      post = Post.new(:content => "This is a post without headings. The summary should be the whole body")
      
      post.summary.should == "<p>This is a post without headings. The summary should be the whole body</p>\n"
    end

    it "should show a 'Read More' link when displaying a summary" do
      pending
    end
  end

end
