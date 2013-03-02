# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class MultiTest < TestCase
    def test_that_it_extracts_links_and_tags
      extraction = extract('Something #tagged with a link http://samsoff.es/posts/hire-sam')
      assert_equal extraction, {
        display_text: 'Something #tagged with a link samsoff.es/posts/hire-sam',
        display_html: 'Something <a href="#hashtag-tagged" class="hashtag">#tagged</a> with a link <a href="http://samsoff.es/posts/hire-sam" rel="external nofollow" class="link">samsoff.es&#x2F;posts&#x2F;hire-sam</a>',
        entities: [
          {
            type: 'hashtag',
            text: '#tagged',
            display_text: '#tagged',
            hashtag: 'tagged',
            indices: [10, 17],
            display_indices: [10, 17]
          },
          {
            type: 'link',
            text: 'http://samsoff.es/posts/hire-sam',
            display_text: 'samsoff.es/posts/hire-sam',
            url: 'http://samsoff.es/posts/hire-sam',
            indices: [30, 62],
            display_indices: [30, 55]
          }
        ]
      }
    end

    def test_that_it_doesnt_lose_the_last_character
      extraction = extract('Something that is **bold**?')
      assert_equal extraction, {
        display_text: 'Something that is bold?',
        display_html: 'Something that is <strong>bold</strong>?',
        entities: [
          {
            type: 'double_emphasis',
            text: '**bold**',
            display_text: 'bold',
            indices: [18, 26],
            display_indices: [18, 22]
          }
        ]
      }

      extraction = extract('Something that is **bold**')
      assert_equal extraction, {
        display_text: 'Something that is bold',
        display_html: 'Something that is <strong>bold</strong>',
        entities: [
          {
            type: 'double_emphasis',
            text: '**bold**',
            display_text: 'bold',
            indices: [18, 26],
            display_indices: [18, 22]
          }
        ]
      }
    end
  end
end
