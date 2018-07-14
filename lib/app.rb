require 'kramdown'
require 'sinatra/base'
require 'sinatra/config_file'

require './lib/bluebozu/entry'
require './lib/bluebozu/entry_base'
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

    tic = Time.now
    EntryBase.load(settings.data_path)
    puts "### Load time: #{Time.now - tic} sec."
  end

  before do
    ACCESS_COUNTER[request.path_info] += 1 if request.request_method == "GET"
  end

  # single entry page
  get '/:id' do |id|
    @pm = SingleEntryPageModel.create(id)
    halt unless @pm
    erb :page_single_entry
  end

  # multi entry page (top is page 1)
  ['/', '/page/:num'].each do |path|
    get path do
      page_num = params.include?(:num) ? params[:num].to_i : 1
      @pm = MultiEntryPageModel.create(page_num, settings.entries_per_page)
      erb :page_multi_entries
    end
  end

  # reload entries data
  get '/admin/reload' do
    EntryBase.load(ARGV[0] || settings.data_path)

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
