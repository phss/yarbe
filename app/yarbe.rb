$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "app"))
require "rubygems"
require "sinatra"
require "haml"
require "sass"
require "builder"
require "model"
require "helpers"

configure do
  set :views, File.dirname(__FILE__) + "/../views"
  
  Blog = OpenStruct.new(
    :title => "Yet Another Ruby Blog Engine",
    :subtitle => "This is just a template blog. Change at will!",
    :author => "Some dude",
    :url => "http://localhost:4567",
    :admin_credentials => ["admin", "Demo123"]
  )
  
  DataMapper::setup(:default, ENV["DATABASE_URL"] || "sqlite3::memory:")
  DataMapper.auto_upgrade!
end

helpers FormattingHelpers, AuthenticationHelpers

# Public stuff

get "/" do
  @posts = Post.all_for_display
  haml :list
end

get "/post/:link" do
  @post = Post.first(:link => params[:link])
  haml :view
end

get "/yarbe.css" do
  content_type "text/css", :charset => "utf-8"
  sass :yarbe
end

# Feed stuff

get "/feed" do
  @posts = Post.all_for_display
  builder :feed
end

# Admin stuff

get "/admin" do
  protected!
  haml :admin
end

get "/admin/new_post" do
  protected!
  @post = Post.new
  haml :new_post
end

post "/admin/publish" do
  protected!
  @post = Post.new(params)
  if @post.save
    @messages = ["Successfully published post"]
    @post = Post.new
  else
    @messages = @post.errors
  end
  haml :new_post
end