# encoding: UTF-8

module Quesadilla
  class Extractor
    module HTML
      HTML_ESCAPE_MAP = [
        {
           pattern: '&',
           text: '&amp;',
           placeholder: "\uf050",
        },
        {
           pattern: '<',
           text: '&lt;',
           placeholder: "\uf051",
        },
        {
           pattern: '>',
           text: '&gt;',
           placeholder: "\uf052",
        },
        {
           pattern: '"',
           text: '&quot;',
           placeholder: "\uf053",
        },
        {
           pattern: '\'',
           text: '&#x27;',
           placeholder: "\uf054",
        },
        {
           pattern: '/',
           text: '&#x2F;',
           placeholder: "\uf055",
        }
      ]

      def display_html(display_text, entities)
         return html_escape(display_text) unless entities and entities.length > 0

         # Replace entities
         html = sub_entities(display_text, entities, true) do |entity|
           html_entity(entity)
        end

         # Return
         html_un_pre_escape(html)
      end

      def html_entity(entity)
         display_text = html_pre_escape(entity[:display_text])
         case entity[:type]
         when ENTITY_TYPE_EMPHASIS
           "<em>#{display_text}</em>"
         when ENTITY_TYPE_DOUBLE_EMPHASIS
           "<strong>#{display_text}</strong>"
         when ENTITY_TYPE_TRIPLE_EMPHASIS
           "<strong><em>#{display_text}</em></strong>"
         when ENTITY_TYPE_STRIKETHROUGH
           "<del>#{display_text}</del>"
         when ENTITY_TYPE_CODE
           "<code>#{display_text}</code>"
         when ENTITY_TYPE_HASHTAG
           "<a href=\"#hashtag-#{html_pre_escape(entity[:hashtag])}\" class=\"tag\">#{display_text}</a>"
         when ENTITY_TYPE_LINK
           title = (entity[:title] and entity[:title].length > 0) ? " title=\"#{html_escape(entity[:title])}\"" : ''
           "<a href=\"#{entity[:url]}\" rel=\"external nofollow\" class=\"link\"#{title}>#{display_text}</a>"
         else
           html_pre_escape(entity[:text])
         end
      end

      # Pre-escape. Convert bad characters to high UTF-8 characters
      # We do this dance so we don't throw off the indexes so the entities get inserted correctly.
      def html_pre_escape(string)
         return '' unless string
         HTML_ESCAPE_MAP.each do |escape|
           string = string.gsub(escape[:pattern], escape[:placeholder])
         end
         string
      end

      # Convert bad characters (now, high UTF-8 characters) to HTML escaped ones
      def html_un_pre_escape(string)
         HTML_ESCAPE_MAP.each do |escape|
           string = string.gsub(escape[:placeholder], escape[:text])
        end
        string
      end

      def html_escape(string)
        return '' unless string
        string.gsub(/&/, '&amp;').gsub(/</, '&lt;').gsub(/>/, '&gt;').gsub(/"/, '&quot;').gsub(/'/, '&#x27;').gsub(/\//, '&#x2F;')
      end
    end
  end
end
