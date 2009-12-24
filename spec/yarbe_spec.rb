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

  describe "(validations)" do
    it "should fail to publish when title is missing" do
      post "/publish", {:content => "I think the title is missing"}, credentials(Config.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Title is required")
    end

    it "should fail to publish when content is missing" do
      post "/publish", {:title => "I think the body is missing"}, credentials(Config.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Content is required")
    end

    it "should fail and display both validation messages when post is empty" do
      post "/publish", {}, credentials(Config.admin_credentials)

      last_response.should be_ok
      last_response.body.should include("Title is required")    
      last_response.body.should include("Content is required")
    end
    
    it "should fail when no credentials are provided" do
      post "/publish", {:title => "I have a title", :content => "And also a content!"}
      
      last_response.status.should == 401
    end
    
    it "should fail when wrong credentials provided" do
      post "/publish", {:title => "I have a title", :content => "And also a content!"}, credentials(["blah", "blah"])

      last_response.status.should == 401
    end
  end
  
  it "should successfully submit a post" do
      post "/publish", {:title => "I have a title", :content => "And also a content!"}, credentials(Config.admin_credentials)
      
      last_response.should be_ok
      last_response.body.should include("Successfully published post")
      Post.all(:title => "I have a title", :content => "And also a content!").size.should == 1
  end
  
  it "should fetch post by link" do
    Post.new(:title => "Some test title", :content => "Testing 1, 2, 3...").save
    
    get "/post/some_test_title"
    
    last_response.should be_ok
    last_response.body.should include("Testing 1, 2, 3...")
  end
end