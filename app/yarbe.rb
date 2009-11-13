$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))
require "rubygems"
require "vendor/sinatra/lib/sinatra.rb"
require "haml"
require "model"
require "helpers"

configure do
  set :views, File.dirname(__FILE__) + "/../views"
  
  DataMapper::setup(:default, ENV["DATABASE_URL"] || "sqlite3::memory:")
  DataMapper.auto_upgrade!
end

helpers FormattingHelpers

get "/" do
  @posts = Post.all(:order => [ :created_at.desc ])
  haml :list
end

get "/new_post" do
  @post = Post.new
  haml :new_post
end

post "/publish" do
  @post = Post.new(params)
  if @post.save
    @messages = ["Successfully published post"]
    @post = Post.new
  else
    @messages = @post.errors
  end
  haml :new_post
end

get "/yarbe.css" do
   content_type "text/css", :charset => "utf-8"
   sass :yarbe
end
