require 'quesadilla/version'
require 'quesadilla/html_renderer'
require 'quesadilla/extractor'

# Ruby library for entity-style text parsing. Quesadilla was extracted from [Cheddar](https://cheddarapp.com).
module Quesadilla
  # Emphasis (italic) entity type
  ENTITY_TYPE_EMPHASIS = 'emphasis'.freeze

  # Double emphasis (bold) entity type
  ENTITY_TYPE_DOUBLE_EMPHASIS = 'double_emphasis'.freeze

  # Triple emphasis (bold italic) entity type
  ENTITY_TYPE_TRIPLE_EMPHASIS = 'triple_emphasis'.freeze

  # Strikethrough entity type
  ENTITY_TYPE_STRIKETHROUGH = 'strikethrough'.freeze

  # Code entity type
  ENTITY_TYPE_CODE = 'code'.freeze

  # Hashtag entity type
  ENTITY_TYPE_HASHTAG = 'hashtag'.freeze

  # User entity type
  ENTITY_TYPE_USER = 'user'.freeze

  # Link entity type
  ENTITY_TYPE_LINK = 'link'.freeze

module_function

  # Extract entities from text
  # @param text [String] the text to extract
  # @option options markdown_code [Boolean] Should extract Markdown code. Defaults to `true`.
  # @option options markdown_links [Boolean] Should extract Markdown links. Defaults to `true`.
  # @option options markdown_triple_emphasis [Boolean] Should extract Markdown triple emphasis (bold italic). Defaults to `true`.
  # @option options markdown_double_emphasis [Boolean] Should extract Markdown double emphasis (bold). Defaults to `true`.
  # @option options markdown_emphasis [Boolean] Should extract Markdown emphasis (italic). Defaults to `true`.
  # @option options markdown_strikethrough [Boolean] Should extract Markdown strikethrough. Defaults to `true`.
  # @option options hashtags [Boolean] Should extract hashtags. Defaults to `true`.
  # @option options hashtag_validator A callable object to validate a hashtag. This should return `true` or `false`. Invalid hashtags will be left as plain text. If the validator is `nil`, all hashtags will be extracted. Defaults to `nil`.
  # @option options autolinks [Boolean] Should automatically detect links. Defaults to `true`.
  # @option options emoji [Boolean] Should extract named emoji. Defaults to `true`.
  # @option options users [Boolean] Should extract user mentions. Defaults to `false`.
  # @option options user_validator A callable object to validate a username. This should return the user ID of the user or nil if it is invalid. Invalid users will be left as plain text. If the validator is nil, all usernames will be extracted. Defaults to `nil`.
  # @option options html [Boolean] Should generate HTML. Defaults to `true`.
  # @option options html_renderer [Class] class to use as HTML renderer. Defaults to `Quesadilla::HTMLRenderer`.
  # @return [Hash] hash containing the display text, html text, and entities
  def extract(text, options = {})
    Extractor.new(options).extract(text)
  end
end
