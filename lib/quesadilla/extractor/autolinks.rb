# encoding: UTF-8

module Quesadilla
  class Extractor
    module Autolinks
      require 'twitter-text'

      def extract_autolinks
        Twitter::Extractor::extract_urls_with_indices(@working_text).each do |entity|
          entity_text = entity[:url]
          @entities << {
            type: 'link',
            text: entity_text,
            display_text: display_url(entity[:url]),
            url: quality_url(entity[:url]),
            indices: entity[:indices]
          }
          @working_text.sub!(entity_text, REPLACE_TOKEN * entity_text.length)
        end
      end
    end
  end
end
