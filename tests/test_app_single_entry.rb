ENV['RACK_ENV'] = 'test'

require './lib/app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  PREV_ENTRY = '« 前の記事'
  NEXT_ENTRY = '次の記事 »'

  def app
    MyApp
  end

  def test_single_entry
    get '/this-is-a-test-1'

    assert last_response.ok?
    ['<h2><a href="/this-is-a-test-1">This is a test entry title</a></h2>',
      '<span class="date">Jan-01-2018</span>',
      '<span class="category">Category01</span>',
      '<p>This is the first line of the test entry.</p>',
      PREV_ENTRY, NEXT_ENTRY
    ].each{ |str| assert last_response.body.include?(str) }
  end

  def test_signle_entry_oldest
    get '/the-oldest-entry'

    assert last_response.ok?
    assert last_response.body.include?(PREV_ENTRY)
    assert_false last_response.body.include?(NEXT_ENTRY)
  end

  def test_signle_entry_newest
    get '/the-newest-entry'

    assert last_response.ok?
    assert_false last_response.body.include?(PREV_ENTRY)
    assert last_response.body.include?(NEXT_ENTRY)
  end
end
