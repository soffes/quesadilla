# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class EmojiTest < TestCase
    def test_that_it_supports_emoji
      extraction = extract('Something with 👨 beardface')
      assert_equal extraction, {
        display_text: 'Something with 👨 beardface',
        display_html: 'Something with 👨 beardface',
        entities: []
      }
    end

    def test_that_it_supports_emoji_with_other_entities
      extraction = extract('Something #tagged with 👨 beardface')
      assert_equal extraction, {
        display_text: 'Something #tagged with 👨 beardface',
        display_html: 'Something <a href="#hashtag-tagged" class="tag">#tagged</a> with 👨 beardface',
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

      extraction = extract('After 💇 #foo 👮 **Yep**')
      assert_equal extraction, {
        display_text: 'After 💇 #foo 👮 Yep',
        display_html: 'After 💇 <a href="#hashtag-foo" class="tag">#foo</a> 👮 <strong>Yep</strong>',
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
    end

    def test_that_it_support_the_colon_syntax
      extraction = extract('Beardface is :man:')
      assert_equal extraction, {
        display_text: 'Beardface is 👨',
        display_html: 'Beardface is 👨',
        entities: []
      }

      extraction = extract('Beardface is `not here :man:` :man:')
      assert_equal extraction, {
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

      # extraction = extract('Something #tagged with :man: **beardface**')
      # assert_equal extraction, {
      #   display_text: 'Something #tagged with 👨 beardface',
      #   display_html: 'Something <a href="#hashtag-tagged" class="tag">#tagged</a> with 👨 <strong>beardface</strong>',
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
    end
  end
end
