# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class HashtagsTest < TestCase
    def test_that_it_extracts_tags
      extraction = extract('Something #tagged')
      assert_equal extraction, {
        display_text: 'Something #tagged',
        display_html: 'Something <a href="#tag-tagged" class="tag">#tagged</a>',
        entities: [
          {
            type: 'tag',
            text: '#tagged',
            display_text: '#tagged',
            tag_name: 'tagged',
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
        display_html: 'A task with some <a href="#tag-tags" class="tag">#tags</a> that are <a href="#tag-awesome" class="tag">#awesome</a>',
        entities: [
          {
            type: 'tag',
            text: '#tags',
            display_text: '#tags',
            tag_name: 'tags',
            indices: [17, 22],
            display_indices: [17, 22]
          },
          {
            type: 'tag',
            text: '#awesome',
            display_text: '#awesome',
            tag_name: 'awesome',
            indices: [32, 40],
            display_indices: [32, 40]
          }
        ]
      }
    end
  end
end
