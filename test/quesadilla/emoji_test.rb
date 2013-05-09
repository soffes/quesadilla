# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class EmojiTest < TestCase
    def test_that_it_supports_emoji
      extraction = extract('Something with 👨 beardface')
      expected = {
        display_text: 'Something with 👨 beardface',
        display_html: 'Something with 👨 beardface',
        entities: []
      }
      assert_equal expected, extraction
    end

    def test_that_it_supports_emoji_with_other_entities
      extraction = extract('Something #tagged with 👨 beardface')
      expected = {
        display_text: 'Something #tagged with 👨 beardface',
        display_html: 'Something <a href="#hashtag-tagged" class="hashtag">#tagged</a> with 👨 beardface',
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

      extraction = extract('After 💇 #foo 👮 **Yep**')
      expected = {
        display_text: 'After 💇 #foo 👮 Yep',
        display_html: 'After 💇 <a href="#hashtag-foo" class="hashtag">#foo</a> 👮 <strong>Yep</strong>',
        entities: [
          {
            type: 'hashtag',
            text: '#foo',
            display_text: '#foo',
            indices: [8, 12],
            hashtag: 'foo',
            display_indices: [8, 12]
          },
          {
            type: 'double_emphasis',
            text: '**Yep**',
            display_text: 'Yep',
            indices: [15, 22],
            display_indices: [15, 18]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_support_the_colon_syntax
      extraction = extract('Beardface is :man:')
      expected = {
        display_text: 'Beardface is 👨',
        display_html: 'Beardface is 👨',
        entities: []
      }
      assert_equal expected, extraction

      extraction = extract('Beardface is `not here :man:` :man:')
      expected = {
        display_text: 'Beardface is not here :man: 👨',
        display_html: 'Beardface is <code>not here :man:</code> 👨',
        entities: [
          {
            type: 'code',
            text: '`not here :man:`',
            display_text: 'not here :man:',
            indices: [13, 29],
            display_indices: [13, 27]
          }
        ]
      }
      assert_equal expected, extraction

      # TODO: This is broken. Original indicies are messed up if a named emoji is before another entity
      # extraction = extract('Something #tagged with :man: **beardface**')
      # expected = {
      #   display_text: 'Something #tagged with 👨 beardface',
      #   display_html: 'Something <a href="#hashtag-tagged" class="hashtag">#tagged</a> with 👨 <strong>beardface</strong>',
      #   entities: [
      #     {
      #       type: 'hashtag',
      #       text: '#tagged',
      #       display_text: '#tagged',
      #       hashtag: 'tagged',
      #       indices: [10, 17],
      #       display_indices: [10, 17]
      #     },
      #     {
      #       type: 'double_emphasis',
      #       text: '**beardface**',
      #       display_text: 'beardface',
      #       indices: [29, 42],
      #       display_indices: [30, 39]
      #     }
      #   ]
      # }
      # assert_equal expected, extraction
    end

    def test_totally_invalid_emoji
      bogus_text = 'Q14hMG4vA1RwLU3gQT9ENs7S.jpeg:Amazon:photo'
      extraction = extract(bogus_text)
      assert_equal bogus_text, extraction[:display_text]
      assert_equal [], extraction[:entities]
    end
  end
end
