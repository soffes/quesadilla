require 'quesadilla/version'
require 'quesadilla/extractor'

module Quesadilla
  ENTITY_TYPE_EMPHASIS = 'emphasis'
  ENTITY_TYPE_DOUBLE_EMPHASIS = 'double_emphasis'
  ENTITY_TYPE_TRIPLE_EMPHASIS = 'triple_emphasis'
  ENTITY_TYPE_STRIKETHROUGH = 'strikethrough'
  ENTITY_TYPE_CODE = 'code'
  ENTITY_TYPE_HASHTAG = 'hashtag'
  ENTITY_TYPE_LINK = 'link'

  def self.extract(text, options = {})
    Extractor.new(options).extract(text)
  end
end
