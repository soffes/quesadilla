# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class HashtagsTest < TestCase
    def test_that_it_extracts_tags
      extraction = extract('Something #tagged')
      assert_equal extraction, {
        display_text: 'Something #tagged',
        display_html: 'Something <a href="#hashtag-tagged" class="tag">#tagged</a>',
        entities: [
          {
            type: 'hashtag',
            text: '#tagged',
            display_text: '#tagged',
            hashtag: 'tagged',
            indices: [10, 17],
            display_indices: [10, 17]
          }
        ]
      }
    end

    def test_that_it_extracts_multiple_tags
      extraction = extract('A task with some #tags that are #awesome')
      assert_equal extraction, {
        display_text: 'A task with some #tags that are #awesome',
        display_html: 'A task with some <a href="#hashtag-tags" class="tag">#tags</a> that are <a href="#hashtag-awesome" class="tag">#awesome</a>',
        entities: [
          {
            type: 'hashtag',
            text: '#tags',
            display_text: '#tags',
            hashtag: 'tags',
            indices: [17, 22],
            display_indices: [17, 22]
          },
          {
            type: 'hashtag',
            text: '#awesome',
            display_text: '#awesome',
            hashtag: 'awesome',
            indices: [32, 40],
            display_indices: [32, 40]
          }
        ]
      }
    end
  end
end
