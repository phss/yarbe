app_file = File.join(File.dirname(__FILE__), *%w[.. .. app yarbe.rb])
require app_file
require 'spec/expectations'
require 'rack/test'
require "webrat"
require "webrat/sinatra"

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Sinatra::Application
  end
end

World{MyWorld.new}
