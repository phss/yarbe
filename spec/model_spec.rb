require "spec_helper"
 
describe "Model" do
  
  SUMMARY_CONTENT_EXAMPLE = <<eos
The summary goes from __here__ until...

...the start of a heading.

This is the end of the summary
-----------------

This should not appear
eos
  
  before(:each) do
    Post.all.destroy!
  end
  
  describe "(validations)" do
  
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
      post = Post.new(:content => SUMMARY_CONTENT_EXAMPLE)
      
      post.summary.should == "<p>The summary goes from <strong>here</strong> until...</p>\n\n<p>...the start of a heading.</p>\n\n"
      post.more?.should be_true
    end

    it "should show whole post as summary in case there is no headings" do
      post = Post.new(:content => "This is a post without headings. The summary should be the whole body")
      
      post.summary.should == "<p>This is a post without headings. The summary should be the whole body</p>\n"
      post.more?.should be_false
    end
  end
  

  describe "(linking)" do
    it "should have a title-based link" do
      post = Post.new(:title => "This is a example 32 of a link")
      
      post.link.should == "this_is_a_example_32_of_a_link"
    end
    
    it "should have a 'invalid_post' link when title is missing" do
      Post.new.link.should == "invalid_post"
    end
  end

end
