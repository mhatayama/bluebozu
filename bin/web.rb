require 'sinatra'
require 'redcarpet'
require './config/config'
require './lib/bouzu'

set :static, true
set :public_folder, "static"
set :views, "views"

get '/' do
  "Index."
end

get '/category/:category' do
  "category: " + params['category']
end

get '/:post_id' do

  render = Redcarpet::Render::HTML
  @markdown = Redcarpet::Markdown.new(render, autolink: true, tables: true)

  @post = Post[params['post_id']]
  erb :index
end
