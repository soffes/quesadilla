# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class AutolinkTest < TestCase
    def test_that_it_extracts_plain_links
      extraction = extract('Something with a link: http://samsoff.es/posts/hire-sam')
      assert_equal extraction, {
        display_text: 'Something with a link: samsoff.es/posts/hire-sam',
        display_html: 'Something with a link: <a href="http://samsoff.es/posts/hire-sam" rel="external nofollow" class="link">samsoff.es&#x2F;posts&#x2F;hire-sam</a>',
        entities: [
          {
            type: 'link',
            text: 'http://samsoff.es/posts/hire-sam',
            display_text: 'samsoff.es/posts/hire-sam',
            url: 'http://samsoff.es/posts/hire-sam',
            indices: [23, 55],
            display_indices: [23, 48]
          }
        ]
      }

      extraction = extract('Try google.com')
      assert_equal extraction, {
        display_text: 'Try google.com',
        display_html: 'Try <a href="http://google.com" rel="external nofollow" class="link">google.com</a>',
        entities: [
          {
            type: 'link',
            text: 'google.com',
            display_text: 'google.com',
            url: 'http://google.com',
            indices: [4, 14],
            display_indices: [4, 14]
          }
        ]
      }
    end

    def test_that_it_pretifies_long_links
      extraction = extract('Something with a long link: https://github.com/samsoffes/api.cheddarapp.com/blob/master/Readme.markdown')
      assert_equal extraction, {
        display_text: 'Something with a long link: github.com/samsoffes/api.chedda…',
        display_html: 'Something with a long link: <a href="https://github.com/samsoffes/api.cheddarapp.com/blob/master/Readme.markdown" rel="external nofollow" class="link">github.com&#x2F;samsoffes&#x2F;api.chedda…</a>',
        entities: [
          {
            type: 'link',
            text: 'https://github.com/samsoffes/api.cheddarapp.com/blob/master/Readme.markdown',
            display_text: 'github.com/samsoffes/api.chedda…',
            url: 'https://github.com/samsoffes/api.cheddarapp.com/blob/master/Readme.markdown',
            indices: [28, 103],
            display_indices: [28, 60]
          }
        ]
      }
    end

    def test_that_it_extracts_multiple_plain_links
      extraction = extract('Something with a link: http://samsoff.es/posts/hire-sam - http://apple.com')
      assert_equal extraction, {
        display_text: 'Something with a link: samsoff.es/posts/hire-sam - apple.com',
        display_html: 'Something with a link: <a href="http://samsoff.es/posts/hire-sam" rel="external nofollow" class="link">samsoff.es&#x2F;posts&#x2F;hire-sam</a> - <a href="http://apple.com" rel="external nofollow" class="link">apple.com</a>',
        entities: [
          {
            type: 'link',
            text: 'http://samsoff.es/posts/hire-sam',
            display_text: 'samsoff.es/posts/hire-sam',
            url: 'http://samsoff.es/posts/hire-sam',
            indices: [23, 55],
            display_indices: [23, 48]
          },
          {
            type: 'link',
            text: 'http://apple.com',
            display_text: 'apple.com',
            url: 'http://apple.com',
            indices: [58, 74],
            display_indices: [51, 60]
          }
        ]
      }
    end
  end
end
