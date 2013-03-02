module Quesadilla
  class Extractor
    # Extract user mentions.
    #
    # This module has no public methods.
    module Users
    private

      require 'twitter-text'

      def extract_users
        Twitter::Extractor::extract_mentioned_screen_names_with_indices(@working_text).each do |entity|
          display_text = '@' + entity[:screen_name]
          username = entity[:screen_name]

          user_id = nil
          if validator = @options[:user_validator]
            user_id = validator.call(username)
            next unless user_id
          end

          hash = {
            type: ENTITY_TYPE_USER,
            text: display_text,
            display_text: display_text,
            indices: entity[:indices],
            username: entity[:screen_name],
          }
          hash[:user_id] = user_id if user_id

          @entities << hash
          @working_text.sub!(display_text, REPLACE_TOKEN * display_text.length)
        end
      end
    end
  end
end
