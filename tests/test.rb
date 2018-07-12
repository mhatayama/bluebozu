ENV['RACK_ENV'] = 'test'

require './lib/app'
require 'test/unit'
require 'rack/test'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    MyApp
  end

  def test_single_entry_page
    get '/this-is-a-test-1'

    assert last_response.ok?
    assert last_response.body.include?('<h2>This is a test entry title</h2>')
    assert last_response.body.include?(
      '<p>This is the first line of the test entry.</p>')
  end
end
