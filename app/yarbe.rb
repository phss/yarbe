$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
require "rubygems"
require "vendor/sinatra/lib/sinatra.rb"
require "haml"
require "model"

configure do
  set :views, File.dirname(__FILE__) + '/../views'
  
  DataMapper::setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
  
  Post.new(:title => "Post One", :body => "This is post one").save
  Post.new(:title => "Post Two", :body => "This is post two").save
end

get '/' do
  @posts = Post.all
  haml :list
end
