require "spec_helper"

describe "YARBE App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
  
  before(:each) do
    Post.all.destroy!
  end

  it "should show all posts" do
    Post.new(:title => "Post One", :body => "This is post one").save
    Post.new(:title => "Post Two", :body => "This is post two").save    
    
    get "/"
    
    last_response.should be_ok
    last_response.body.should include("Post One")
    last_response.body.should include("This is post one")
    last_response.body.should include("Post Two")
    last_response.body.should include("This is post two")    
  end
end