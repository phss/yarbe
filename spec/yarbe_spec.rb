require "spec_helper"

set :environment, :test

describe "YARBE App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get "/"
    last_response.should be_ok
    last_response.body.should == "Blah"
  end
end