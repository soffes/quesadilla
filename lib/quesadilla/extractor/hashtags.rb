# encoding: UTF-8

module Quesadilla
  class Extractor
    # Extract hashtags.
    #
    # This module has no public methods.
    module Hashtags
    private

      require 'twitter-text'

      def extract_hashtags
        Twitter::Extractor::extract_hashtags_with_indices(@working_text).each do |entity|
          hashtag = entity[:hashtag]

          # Validate
          if validator = @options[:hashtag_validator]
            next unless validator.call(hashtag)
          end

          display_text = "##{hashtag}"
          @entities << {
            type: ENTITY_TYPE_HASHTAG,
            text: display_text,
            display_text: display_text,
            indices: entity[:indices],
            hashtag: hashtag.downcase
          }
          @working_text.sub!(display_text, REPLACE_TOKEN * display_text.length)
        end
      end
    end
  end
end
