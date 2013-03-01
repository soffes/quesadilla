# encoding: UTF-8

module Quesadilla
  class Extractor
    module Hashtags
      require 'twitter-text'

      def extract_hashtags
        Twitter::Extractor::extract_hashtags_with_indices(@working_text).each do |entity|
          entity_text = "##{entity[:hashtag]}"
          @entities << {
            type: ENTITY_TYPE_HASHTAG,
            text: entity_text,
            display_text: entity_text,
            indices: entity[:indices],
            hashtag: entity[:hashtag].downcase
          }
          @working_text.sub!(entity_text, REPLACE_TOKEN * entity_text.length)
        end
      end
    end
  end
end
