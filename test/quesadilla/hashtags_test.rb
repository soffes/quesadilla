# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class HashtagsTest < TestCase
    def test_that_it_extracts_tags
      extraction = extract('Something #tagged')
      expected = {
        display_text: 'Something #tagged',
        display_html: 'Something <a href="#hashtag-tagged" class="hashtag">#tagged</a>',
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
      assert_equal expected, extraction
    end

    def test_that_it_extracts_multiple_tags
      extraction = extract('A task with some #tags that are #awesome')
      expected = {
        display_text: 'A task with some #tags that are #awesome',
        display_html: 'A task with some <a href="#hashtag-tags" class="hashtag">#tags</a> that are <a href="#hashtag-awesome" class="hashtag">#awesome</a>',
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
      assert_equal expected, extraction
    end

    def test_that_it_validates
      validator = lambda do |hashtag|
        hashtag == 'awesome'
      end
      extraction = extract('A task with some #tags that are #awesome', hashtag_validator: validator)
      expected = {
        display_text: 'A task with some #tags that are #awesome',
        display_html: 'A task with some #tags that are <a href="#hashtag-awesome" class="hashtag">#awesome</a>',
        entities: [
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
      assert_equal expected, extraction
    end
  end
end
