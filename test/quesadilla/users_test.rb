# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class AutolinkTest < TestCase
    def test_extracting_users
      extraction = extract('You should follow @soffes on Twitter', users: true)
      expected = {
        display_text: 'You should follow @soffes on Twitter',
        display_html: 'You should follow <a href="/soffes" class="user">@soffes</a> on Twitter',
        entities: [
          {
            type: 'user',
            text: '@soffes',
            display_text: '@soffes',
            username: 'soffes',
            indices: [18, 25],
            display_indices: [18, 25]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_user_validation
      validator = lambda do |username|
        username == 'soffes' ? 4 : nil
      end

      extraction = extract('You should follow @soffes on Twitter, but not @crap', users: true, user_validator: validator)
      expected = {
        display_text: 'You should follow @soffes on Twitter, but not @crap',
        display_html: 'You should follow <a href="/soffes" class="user">@soffes</a> on Twitter, but not @crap',
        entities: [
          {
            type: 'user',
            text: '@soffes',
            display_text: '@soffes',
            username: 'soffes',
            user_id: 4,
            indices: [18, 25],
            display_indices: [18, 25]
          }
        ]
      }
      assert_equal expected, extraction

    end
  end
end
