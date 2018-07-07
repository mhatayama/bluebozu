require 'kramdown'
require 'sinatra/base'
require 'sinatra/config_file'

require './lib/bluebozu/post'
require './lib/bluebozu/post_base'
require './lib/bluebozu/page_model'

class MyApp < Sinatra::Base
  register Sinatra::ConfigFile
  config_file '../config/config.yml'

  configure do
    set :layout => :layout
    set :public_folder, "static"
    set :static, true
    set :views, "views"

    ACCESS_COUNTER = Hash.new(0)
    START_TIME = Time.new

    PostBase.load(ARGV[0] || settings.data_path)
  end

  before do
    ACCESS_COUNTER[request.path_info] += 1 if request.request_method == "GET"
  end

  # single post page
  get '/:id' do |id|
    @pm = SinglePostPageModel.create(id)
    halt unless @pm
    erb :page_single_post
  end

  # multi post page (top is page 1)
  ['/', '/page/:num'].each do |path|
    get path do
      page_num = params.include?(:num) ? params[:num].to_i : 1
      @pm = MultiPostPageModel.create(page_num, settings.posts_per_page)
      erb :page_multi_posts
    end
  end

  # reload posts data
  get '/admin/reload' do
    Post.load(ARGV[0] || settings.posts_path)

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
end
