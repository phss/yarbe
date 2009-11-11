$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
require "rubygems"
require "vendor/sinatra/lib/sinatra.rb"
require "haml"
require "model"
require "helpers"

configure do
  set :views, File.dirname(__FILE__) + '/../views'
  
  DataMapper::setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
  
  # FIXME: remove this, eventually
  Post.new(:title => "Post One", :body => "This is post one").save
  Post.new(:title => "Post Two", :body => "This is post two").save
end

helpers FormattingHelpers

get '/' do
  @posts = Post.all(:order => [ :created_at.desc ])
  haml :list
end

get '/new_post' do
  haml :new_post
end

post '/publish' do
  "<div id='message'>Title is required</div>"
end

get '/yarbe.css' do
   content_type 'text/css', :charset => 'utf-8'
   sass :yarbe
end
