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
  
  # DataMapper::setup(:default, ENV["DATABASE_URL"] || "sqlite3::memory:")
  DataMapper::setup(:default, "sqlite3:blah.db")
  DataMapper.auto_upgrade!
end

helpers FormattingHelpers, AuthenticationHelpers do
  def save_or_update(post)
    if post.save
      @messages = ["Successfully saved/updated post"]
      post = Post.new
    else
      @messages = post.errors
    end
    haml :new_post, :locals => {:post => post, :action_url => params[:action_url]}
  end
end

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

get "/admin/?" do
  protected!
  @posts = Post.all_for_display
  haml :admin
end

get "/admin/new_post" do
  protected!
  haml :new_post, :locals => {:post => Post.new, :action_url => "publish"}
end

post "/admin/publish" do
  protected!
  save_or_update(Post.new(:title => params[:title], :content => params[:content]))
end

get "/admin/edit/:id" do
  protected!
  haml :new_post, :locals => {:post => Post.get(params[:id]), :action_url => "update"}
end

post "/admin/update" do
  protected!
  post = Post.get(params[:postid])
  post.title = params[:title]
  post.content = params[:content]
  save_or_update(post)
end

get "/admin/delete/:id" do # TODO: Should be a post
  protected!
  post = Post.get(params[:id])
  post.destroy if post
  redirect "/admin"
end