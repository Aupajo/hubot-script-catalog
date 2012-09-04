require 'bundler/setup'
require 'sinatra'
require 'active_support/core_ext/object/blank'
require './brain'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
  
  def format_description(d)
    escape_html(d).gsub(/\n/, "<br>")
  end
  
  def format_authors(authors)
    authors.split("\n").join(", ")
  end
end

def all_scripts
  scripts = []
  
  $redis.keys('scripts:*').each do |key|
    scripts << $redis.hgetall(key).merge('name' => key.split(':').last)
  end
  
  scripts.sort_by { |s| s['name'] }
end

error do
  503
end

get '/' do
  raise 'herp'
  @scripts = all_scripts
  @last_updated = Time.parse($redis['last_updated'])
  erb :index
end

get '/stylesheets/master.css' do
  sass :master
end