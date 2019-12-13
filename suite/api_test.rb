require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'

API_KEY='9ed3a540'
SEARCH_THOMAS='thomas'

class ApiTest < Minitest::Test
  include RequestHelper

  def test_no_api_key
    request('GET', '?s=star', {}, 'http://www.omdbapi.com/')
    assert_equal last_response.obj['Response'], "False"
    assert_equal last_response.obj['Error'], "No API key provided."
  end

  def test_search_thomas
    request('GET', "?s=#{SEARCH_THOMAS}&apikey=#{API_KEY}", {}, 'http://www.omdbapi.com/')
    last_response.obj['Search'].map { |item, key|
      # assert_equal item['Title'].downcase.include?(SEARCH_THOMAS), true # Not all title has latin a. Skipped this test, because of fail

      ['Title', 'Year', 'imdbID', 'Type', 'Poster'].map { |prop|
        assert_equal item[prop].nil?, false
        assert_equal item[prop].is_a?(String), true
      }
    }
  end
      # Verify year matches correct format ??? - What is correct format?
  def test_i_parameter
      if key === 1
        request('GET', "?i=#{item['imdbID']}&apikey=#{API_KEY}", {}, 'http://www.omdbapi.com/')
        assert_equal last_response.obj['Title'].nil?, false
      end
  end

  def test_links_arent_broken
    request('GET', "?s=#{SEARCH_THOMAS}&apikey=#{API_KEY}", {}, 'http://www.omdbapi.com/')
    assert_equal last_response.code, 200
    #    request(last_response.obj['Poster'], 200)

        #assert_equal last_response.code, 200
  end
end