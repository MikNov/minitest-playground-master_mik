require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'

API_KEY='9ed3a540'
SEARCH_THOMAS='thomas'

class ApiTest < Minitest::Test
  include RequestHelper

  # 2. Add an assertion to suite/test_no_api_key to ensure the response at runtime matches what is currently displayed with the api key missing
  def test_no_api_key
    request('GET', '?s=star', {}, 'http://www.omdbapi.com/')
    assert_equal last_response.obj['Response'], "False"
    assert_equal last_response.obj['Error'], "No API key provided."
  end

  # 3. Extend suite/api_test.rb by creating a test that performs a search on 'thomas'.
  def test_search_thomas
    request('GET', "?s=#{SEARCH_THOMAS}&apikey=#{API_KEY}", {}, 'http://www.omdbapi.com/')
    last_response.obj['Search'].map { |item|
      assert_equal item['Title'].downcase.include?(SEARCH_THOMAS), true

      ['Title', 'Year', 'imdbID', 'Type', 'Poster'].map { |prop|
        assert_equal item[prop].nil?, false
        assert_equal item[prop].is_a?(String), true
      }
    }
  end

  # 4. Add a test that uses the i parameter to verify each title on page 1 is accessible via imdbID
  def test_i_parameter
        request('GET', "?i=#{}&page=#{'1'}&apikey=#{API_KEY}", {}, 'http://www.omdbapi.com/')
        assert_equal last_response.obj['Title'].nil?, false
  end

  # 5. Add a test that verifies none of the poster links on page 1 are broken
  def test_links_arent_broken
    request('GET', "?i=#{}&page=#{'1'}&apikey=#{API_KEY}", {}, 'http://www.omdbapi.com/')
    assert_equal last_response.RestClient.get(Poster) , 200

  end
end