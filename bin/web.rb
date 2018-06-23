require 'sinatra'
require './config/config'
require './lib/bluebozu/post_builder'

configure do
  require 'sequel'

  DB = Sequel.sqlite
  posts_path = ARGV[0] || $cfg[:posts_path]
  PostBuilder.create_table
  PostBuilder.build(posts_path)

  require 'redcarpet'
  REDCARPET = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML, $cfg[:redcarpet_opts])

  require "./lib/bluebozu/post"
  require "./lib/bluebozu/page_value"

  set :static, true
  set :public_folder, "static"
  set :views, "views"
  set :layout => :layout
end

# single post page
get '/:post_id' do |post_id|
  @pv = SinglePostPageValue.build(post_id)
  erb :page_post
end

# multi post page (top is page 1)
['/', '/page/:num'].each do |path|
  get path do
    page_num = params.include?(:num) ? params[:num].to_i : 1
    @pv = MultiPostPageValue.build(page_num)
    erb :page_paging
  end
end
