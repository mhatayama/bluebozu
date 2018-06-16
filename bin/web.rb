require './config/config'

require 'sequel'
DB = Sequel.connect($cfg[:sequel_conn])

require 'redcarpet'
REDCARPET = Redcarpet::Markdown.new(
  Redcarpet::Render::HTML, $cfg[:redcarpet_opts])

require "./lib/bluebozu/post"
require 'sinatra'

set :static, true
set :public_folder, "static"
set :views, "views"
set :layout => :layout

# single post
get '/:post_id' do |post_id|
  @post = Post[post_id]
  erb :page_post
end

# paging (index is page 1)
['/', '/page/:num'].each do |path|
  get path do
    page_num = params.include?(:num) ? params[:num].to_i : 1
    posts_cnt = Post.count

    offset = (page_num.to_i - 1) * $cfg[:posts_per_page]
    @posts = Post.reverse_order(:date)
        .limit($cfg[:posts_per_page]).offset(offset)
    @prev_page_num = page_num > 1 ? page_num - 1 : nil
    @next_page_num = posts_cnt > page_num * $cfg[:posts_per_page] ?
        page_num + 1 : nil

    erb :page_paging
  end
end
