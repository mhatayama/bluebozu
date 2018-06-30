require 'sinatra'
require 'redcarpet'
require './lib/bluebozu'

configure do
  posts_path = ARGV[0] || $cfg[:posts_path]
  Post.load(posts_path)

  REDCARPET = Redcarpet::Markdown.new(CustomRender, $cfg[:redcarpet_opts])
  ACCESS_COUNTER = Hash.new(0)
  START_TIME = Time.new

  set :static, true
  set :public_folder, "static"
  set :views, "views"
  set :layout => :layout
end

before do
  ACCESS_COUNTER[request.path_info] += 1 if request.request_method == "GET"
end

# single post page
get '/:post_id' do |post_id|
  @pm = SinglePostPageModel.create(post_id)
  halt unless @pm
  erb :page_single_post
end

# multi post page (top is page 1)
['/', '/page/:num'].each do |path|
  get path do
    page_num = params.include?(:num) ? params[:num].to_i : 1
    @pm = MultiPostPageModel.create(page_num)
    erb :page_multi_posts
  end
end

# reload posts data
get '/admin/reload' do
  posts_path = ARGV[0] || $cfg[:posts_path]
  Post.load(posts_path)

  headers 'Content-Type' => 'text/plain'
  body 'Reload OK'
end

# show access stat
get '/admin/stat' do
  sorted = ACCESS_COUNTER.sort{|(k1, v1), (k2, v2)| v2 <=> v1 }.map{|ary|
    sprintf("%4d    %s", ary[1], ary[0])
  }.join("\n")

  headers 'Content-Type' => 'text/plain'
  body "Start: #{START_TIME.to_s}\n\n" + sorted
end
