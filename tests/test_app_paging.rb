ENV['RACK_ENV'] = 'test'

require './lib/app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  ENTRIES_PER_PAGE = 3
  PREV_PAGE = '« 前のページ'
  NEXT_PAGE = '次のページ »'

  def app
    MyApp
  end

  def test_paging_page_one
    get '/page/1'

    assert last_response.ok?
    assert_false last_response.body.include?(PREV_PAGE)
    assert last_response.body.include?(NEXT_PAGE)
  end

  def test_paging_top_is_same_as_page_one
    get '/'
    top_page = last_response.body
    get '/page/1'
    assert_equal top_page, last_response.body
  end

  def test_paging_second_page
    get '/page/2'

    assert last_response.ok?
    assert last_response.body.include?(PREV_PAGE)
    assert last_response.body.include?(NEXT_PAGE)
  end

  def test_paging_last_page
    last_page = (EntryBase.count / ENTRIES_PER_PAGE.to_f).ceil
    get "/page/#{last_page}"

    assert last_response.ok?
    assert last_response.body.include?(PREV_PAGE)
    assert_false last_response.body.include?(NEXT_PAGE)
  end
end
