require 'quesadilla/version'
require 'quesadilla/extractor'

module Quesadilla
  def self.extract(text, options = {})
    Extractor.new(options).extract(text)
  end
end
