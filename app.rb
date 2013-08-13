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

  def content_tag(tag, content, options = {})
    attrs = options.inject("") do |str, (k,v)|
      str << " #{k}=\"#{v}\""
    end
    "<#{tag}#{attrs}>#{content}</#{tag}>"
  end

  def link_unless_current(content, path)
    if path == request.path
      content_tag(:span, content, class: 'active')
    else
      content_tag(:a, content, href: path)
    end
  end
end

def all_scripts
  $redis.keys('scripts:*').map do |key|
    $redis.hgetall(key).tap do |script|
      script['name'] = key.split(':').last
      script['last_updated_at'] = Time.parse(script['last_updated_at'])
      script['added_at'] = Time.parse(script['added_at'])
    end
  end
end

error do
  503
end

get '/' do
  @scripts = all_scripts.sort_by { |s| s['name'] }
  @last_updated = Time.parse($redis['last_updated'])
  erb :index
end

get '/recent' do
  @scripts = all_scripts.sort { |a,b| b['added_at'] <=> a['added_at'] }
  @last_updated = Time.parse($redis['last_updated'])
  erb :index
end

get '/stylesheets/master.css' do
  sass :master
end