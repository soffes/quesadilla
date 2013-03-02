# encoding: UTF-8
require 'test_helper'

module Quesadilla
  class MarkdownTest < TestCase
    def test_that_it_extracts_links
      extraction = extract('Read [my resume](http://samsoff.es/resume) if you want')
      expected = {
        display_text: 'Read my resume if you want',
        display_html: 'Read <a href="http://samsoff.es/resume" rel="external nofollow" class="link">my resume</a> if you want',
        entities: [
          {
            type: 'link',
            text: '[my resume](http://samsoff.es/resume)',
            display_text: 'my resume',
            url: 'http://samsoff.es/resume',
            indices: [5, 42],
            display_indices: [5, 14]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_links_with_titles
      extraction = extract('Read [my resume](http://samsoff.es/resume "Sam\'s Resume") if you want')
      expected = {
        display_text: 'Read my resume if you want',
        display_html: 'Read <a href="http://samsoff.es/resume" rel="external nofollow" class="link" title="Sam&#x27;s Resume">my resume</a> if you want',
        entities: [
          {
            type: 'link',
            text: '[my resume](http://samsoff.es/resume "Sam\'s Resume")',
            display_text: 'my resume',
            url: 'http://samsoff.es/resume',
            title: 'Sam\'s Resume',
            indices: [5, 57],
            display_indices: [5, 14]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_links_with_brackets
      extraction = extract('Something with a link: <http://samsoff.es/posts/hire-sam>')
      expected = {
        display_text: 'Something with a link: samsoff.es/posts/hire-sam',
        display_html: 'Something with a link: <a href="http://samsoff.es/posts/hire-sam" rel="external nofollow" class="link">samsoff.es&#x2F;posts&#x2F;hire-sam</a>',
        entities: [
          {
            type: 'link',
            text: '<http://samsoff.es/posts/hire-sam>',
            display_text: 'samsoff.es/posts/hire-sam',
            url: 'http://samsoff.es/posts/hire-sam',
            indices: [23, 57],
            display_indices: [23, 48]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_email_addresses_with_brackets
      extraction = extract('Email <support@cheddarapp.com>')
      expected = {
        display_text: 'Email support@cheddarapp.com',
        display_html: 'Email <a href="mailto:support@cheddarapp.com" rel="external nofollow" class="link">support@cheddarapp.com</a>',
        entities: [
          {
            type: 'link',
            text: '<support@cheddarapp.com>',
            display_text: 'support@cheddarapp.com',
            url: 'mailto:support@cheddarapp.com',
            indices: [6, 30],
            display_indices: [6, 28]
          }
        ]
      }
      assert_equal expected, extraction
    end

    # it 'should extract plain email addresses'

    def test_that_it_extracts_emphasis
      extraction = extract('Something *cool* is awesome')
      expected = {
        display_text: 'Something cool is awesome',
        display_html: 'Something <em>cool</em> is awesome',
        entities: [
          {
            type: 'emphasis',
            text: '*cool*',
            display_text: 'cool',
            indices: [10, 16],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction

      extraction = extract('Something _cool_ is awesome')
      expected = {
        display_text: 'Something cool is awesome',
        display_html: 'Something <em>cool</em> is awesome',
        entities: [
          {
            type: 'emphasis',
            text: '_cool_',
            display_text: 'cool',
            indices: [10, 16],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_double_emphasis
      extraction = extract('Something **cool** is awesome')
      expected = {
        display_text: 'Something cool is awesome',
        display_html: 'Something <strong>cool</strong> is awesome',
        entities: [
          {
            type: 'double_emphasis',
            text: '**cool**',
            display_text: 'cool',
            indices: [10, 18],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction

      extraction = extract('Something __cool__ is awesome')
      expected = {
        display_text: 'Something cool is awesome',
        display_html: 'Something <strong>cool</strong> is awesome',
        entities: [
          {
            type: 'double_emphasis',
            text: '__cool__',
            display_text: 'cool',
            indices: [10, 18],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_triple_emphasis
      extraction = extract('Something ***cool*** is awesome')
      expected = {
        display_text: 'Something cool is awesome',
        display_html: 'Something <strong><em>cool</em></strong> is awesome',
        entities: [
          {
            type: 'triple_emphasis',
            text: '***cool***',
            display_text: 'cool',
            indices: [10, 20],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction

      extraction = extract('Something ___cool___ is awesome')
      expected = {
        display_text: 'Something cool is awesome',
        display_html: 'Something <strong><em>cool</em></strong> is awesome',
        entities: [
          {
            type: 'triple_emphasis',
            text: '___cool___',
            display_text: 'cool',
            indices: [10, 20],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_strikethrough
      extraction = extract('Something ~~cool~~ awesome')
      expected = {
        display_text: 'Something cool awesome',
        display_html: 'Something <del>cool</del> awesome',
        entities: [
          {
            type: 'strikethrough',
            text: '~~cool~~',
            display_text: 'cool',
            indices: [10, 18],
            display_indices: [10, 14]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_multiple_strikethroughs
      extraction = extract('Something ~~cool~~ awesome ~~foo~~')
      expected = {
        display_text: 'Something cool awesome foo',
        display_html: 'Something <del>cool</del> awesome <del>foo</del>',
        entities: [
          {
            type: 'strikethrough',
            text: '~~cool~~',
            display_text: 'cool',
            indices: [10, 18],
            display_indices: [10, 14]
          },
          {
            type: 'strikethrough',
            text: '~~foo~~',
            display_text: 'foo',
            indices: [27, 34],
            display_indices: [23, 26]
          }
        ]
      }
      assert_equal expected, extraction
    end

    def test_that_it_extracts_code
      extraction = extract('Something with `code` is awesome')
      expected = {
        display_text: 'Something with code is awesome',
        display_html: 'Something with <code>code</code> is awesome',
        entities: [
          {
            type: 'code',
            text: '`code`',
            display_text: 'code',
            indices: [15, 21],
            display_indices: [15, 19]
          }
        ]
      }
      assert_equal expected, extraction
    end
  end
end
