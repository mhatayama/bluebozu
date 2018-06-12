require 'sinatra'
require 'redcarpet'
require './config/config'
require './lib/bouzu'

set :static, true
set :public_folder, "static"
set :views, "views"
set :layout => :layout

get '/' do
  @title = 'MASATO HATAYAMA'
  @posts = Post.reverse_order(:date)
  erb :page_index
end

# get '/category/:category' do
#   "category: " + params['category']
# end

get '/:post_id' do
  @post = Post[params['post_id']]
  erb :page_post
end
