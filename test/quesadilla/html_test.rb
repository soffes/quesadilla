# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class CustomRenderer < HTMLRenderer
    def hashtag(display_text, hashtag)
      %Q{<a href="#tag-#{hashtag}" class="tag">#{display_text}</a>}
    end
  end


  class HTMLTest < TestCase
    def test_hashtag_url_format
      extraction = extract('Something #tagged')
      assert_equal 'Something <a href="#hashtag-tagged" class="hashtag">#tagged</a>', extraction[:display_html]

      extraction = extract('Something #tagged', html_renderer: CustomRenderer)
      assert_equal 'Something <a href="#tag-tagged" class="tag">#tagged</a>', extraction[:display_html]
    end
  end
end
