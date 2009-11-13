require "spec_helper"

set :environment, :test

describe 'YARBE App' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "(validations)" do
    it "should fail to publish when title is missing" do
      post "/publish", :content => "I think the title is missing"

      last_response.should be_ok
      last_response.body.should include("Title is required")
    end

    it "should fail to publish when content is missing" do
      post "/publish", :title => "I think the body is missing"

      last_response.should be_ok
      last_response.body.should include("Content is required")
    end

    it "should fail and display both validation messages when post is empty" do
      post "/publish"

      last_response.should be_ok
      last_response.body.should include("Title is required")    
      last_response.body.should include("Content is required")
    end
  end
  
  it "should successfully submit a post" do
      post "/publish", :title => "I have a title", :content => "And also a content!"
      
      last_response.should be_ok
      last_response.body.should include("Successfully published post")
      Post.all(:title => "I have a title", :content => "And also a content!").size.should == 1
  end
end