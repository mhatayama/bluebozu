ENV['RACK_ENV'] = 'test'

require './lib/app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    MyApp
  end

  def test_single_entry
    get '/this-is-a-test-1'

    assert last_response.ok?
    ['<h2>This is a test entry title</h2>',
      '<a href="/this-is-a-test-1" class="permlink">∞</a>',
      '<span class="date">Jan-01-2018</span>',
      '<span class="category">Category01</span>',
      '<p>This is the first line of the test entry.</p>',
      '« 前の記事', '次の記事 »'
    ].each{ |str| assert last_response.body.include?(str) }
  end

  def test_signle_entry_oldest
    get '/the-oldest-entry'

    assert last_response.ok?
    assert last_response.body.include?('« 前の記事')
    assert_false last_response.body.include?('次の記事 »')
  end

  def test_signle_entry_newest
    get '/the-newest-entry'

    assert last_response.ok?
    assert_false last_response.body.include?('« 前の記事')
    assert last_response.body.include?('次の記事 »')
  end
end
