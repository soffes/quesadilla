# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class HTMLTest < TestCase
    def test_hashtag_url_format
      extraction = extract('Something #tagged')
      assert_equal 'Something <a href="#hashtag-tagged" class="hashtag">#tagged</a>', extraction[:display_html]

      extraction = extract('Something #tagged', hashtag_url_format: '#tag-HASHTAG', hashtag_class_name: 'tag')
      assert_equal 'Something <a href="#tag-tagged" class="tag">#tagged</a>', extraction[:display_html]
    end
  end
end
