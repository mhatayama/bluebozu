require 'sinatra'
require 'redcarpet'
require './lib/bluebozu'

configure do
  posts_path = ARGV[0] || $cfg[:posts_path]
  Post.load(posts_path)

  REDCARPET = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML, $cfg[:redcarpet_opts])

  set :static, true
  set :public_folder, "static"
  set :views, "views"
  set :layout => :layout
end

# single post page
get '/:post_id' do |post_id|
  @pm = SinglePostPageModel.build(post_id)
  erb :page_single_post
end

# multi post page (top is page 1)
['/', '/page/:num'].each do |path|
  get path do
    page_num = params.include?(:num) ? params[:num].to_i : 1
    @pm = MultiPostPageModel.build(page_num)
    erb :page_multi_posts
  end
end
