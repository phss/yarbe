require "spec_helper"
require "base64"

set :environment, :test

describe 'YARBE App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  def credentials(credentials)
    {'HTTP_AUTHORIZATION' => "Basic " + Base64.encode64("#{credentials[0]}:#{credentials[1]}")}
  end
  
  describe "(viewing)" do
    it "should fetch post by link" do
      Post.new(:title => "Some test title", :content => "Testing 1, 2, 3...").save

      get "/post/some_test_title"

      last_response.should be_ok
      last_response.body.should include("Testing 1, 2, 3...")
    end
  end

  describe "(publishing)" do
    it "should fail to publish when title is missing" do
      post "/admin/publish", {:content => "I think the title is missing"}, credentials(Blog.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Title is required")
    end

    it "should fail to publish when content is missing" do
      post "/admin/publish", {:title => "I think the body is missing"}, credentials(Blog.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Content is required")
    end

    it "should fail and display both validation messages when post is empty" do
      post "/admin/publish", {}, credentials(Blog.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Title is required")    
      last_response.body.should include("Content is required")
    end
    
    it "should fail when no credentials are provided" do
      post "/admin/publish", {:title => "I have a title", :content => "And also a content!"}
      
      last_response.status.should == 401
    end
    
    it "should fail when wrong credentials provided" do
      post "/admin/publish", {:title => "I have a title", :content => "And also a content!"}, credentials(["blah", "blah"])

      last_response.status.should == 401
    end
    
    it "should successfully submit a post" do
      post "/admin/publish", {:title => "I have a title", :content => "And also a content!"}, credentials(Blog.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Successfully saved/updated post")
      Post.all(:title => "I have a title", :content => "And also a content!").size.should == 1
    end
  end
  
  describe "(deleting)" do
    it "should successfully delete a post" do
      p = Post.new(:title => "To be deleted", :content => "I don't care!")
      p.save

      get "/admin/delete/#{p.id}", {:id => p.id}, credentials(Blog.admin_credentials)

      last_response.should be_redirect
      Post.all(:title => "To be deleted").size.should == 0
    end
    
    it "should ignore failure when post does not exist" do
      get "/admin/delete/12345567", {:id => 12345567}, credentials(Blog.admin_credentials)

      last_response.should be_redirect
    end
  end
  
  describe "(editing)" do
    it "should successfully update a post" do
      p = Post.new(:title => "To be updated", :content => "I don't care!")
      p.save
      
      post "/admin/update", {:postid => p.id, :title => "Title updated", :content => "Changed"}, credentials(Blog.admin_credentials)
      
      last_response.should be_ok
      last_response.body.should include("Successfully saved/updated post")
      p = Post.get(p.id)
      p.title.should == "Title updated"
      p.content.should == "Changed"
    end
  end
end