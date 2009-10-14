$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))

require "rubygems"
require "spec"
require "rack/test"
require "yarbe"

set :environment, :test

DataMapper::setup(:default, "sqlite3::memory:")
DataMapper.auto_migrate!

Spec::Runner.configure do |conf|
  conf.include Rack::Test::Methods
end