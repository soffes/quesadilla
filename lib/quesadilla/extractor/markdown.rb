# encoding: UTF-8

module Quesadilla
  class Extractor
    # Extract Markdown
    #
    # This module has no public methods.
    module Markdown
    private

      # Gruber's regex is recursive, but I can't figure out how to do it in Ruby without the `g` option.
      # Maybe I should use StringScanner instead. For now, I think it's fine. Everything appears to work
      # as expected.
      NESTED_BRACKETS_REGEX = %r{
        (?>
           [^\[\]]+
        )*
      }x.freeze

      # 2 = Text, 3 = URL, 6 = Title
      LINK_REGEX = %r{
        (
          \[
            (#{NESTED_BRACKETS_REGEX})
          \]
          \(
            [ \t]*
          <?(.*?)>?
            [ \t]*
          (
            (['"])
            (.*?)
            \5
          )?
          \)
        )
      }x.freeze

      # 1 = URL
      AUTOLINK_LINK_REGEX = /<((?:https?|ftp):[^'">\s]+)>/i.freeze

      # 1 = Email
      AUTOLINK_EMAIL_REGEX = %r{
        <
            (?:mailto:)?
        (
          [-.\w]+
          \@
          [-a-z0-9]+(?:\.[-a-z0-9]+)*\.[a-z]+
        )
        >
      }xi.freeze

      # 1 = Delimiter, 2 = Text
      BOLD_ITALIC_REGEX = %r{ (\*\*\*|___) (?=\S) (.+?[*_]*) (?<=\S) \1 }x.freeze

      # 1 = Delimiter, 2 = Text
      BOLD_REGEX = %r{ (\*\*|__) (?=\S) (.+?[*_]*) (?<=\S) \1 }x.freeze

      # 1 = Delimiter, 2 = Text
      ITALIC_REGEX = %r{ (\*|_) (?=\S) (.+?) (?<=\S) \1 }x.freeze

      # 1 = Delimiter, 2 = Text
      STRIKETHROUGH_REGEX = %r{ (~~) (?=\S) (.+?[~]*) (?<=\S) \1 }x.freeze

      # 1 = Delimiter, 2 = Text
      CODE_REGEX = %r{ (`+) (.+?) (?<!`) \1 (?!`) }x.freeze

      def extract_markdown
        extract_markdown_code if @options[:markdown_code]

        if @options[:markdown_links]
          extract_markdown_autolink_links
          extract_markdown_autolink_email
          extract_markdown_links
        end

        extract_markdown_span(BOLD_ITALIC_REGEX, ENTITY_TYPE_TRIPLE_EMPHASIS) if @options[:markdown_triple_emphasis]
        extract_markdown_span(BOLD_REGEX, ENTITY_TYPE_DOUBLE_EMPHASIS) if @options[:markdown_double_emphasis]
        extract_markdown_span(ITALIC_REGEX, ENTITY_TYPE_EMPHASIS) if @options[:markdown_emphasis]
        extract_markdown_span(STRIKETHROUGH_REGEX, ENTITY_TYPE_STRIKETHROUGH) if @options[:markdown_strikethrough]
      end

    private

      def extract_markdown_span(regex, type)
        # Match until there's no results
        while match = @working_text.match(regex)
          original = match[0]
          length = original.length

          # Find the start position of the original
          start = @working_text.index(original)

          # Create the entity
          entity = {
            type: type,
            text: original,
            display_text: match[2],
            indices: [
              start,
              start + length
            ]
          }

          # Let block modify
          entity = yield(entity, match) if block_given?

          # Add the entity
          @entities << entity

          # Remove from the working text
          @working_text.sub!(original, REPLACE_TOKEN * length)
        end
      end

      def extract_markdown_code
        extract_markdown_span(CODE_REGEX, 'code') do |entity, match|
          # Strip tabs from the display text
          display = match[2]
          display.gsub!(/^[ \t]*/, '')
          display.gsub!(/[ \t]*$/, '')
          entity[:display_text] = display
          entity
        end
      end

      def extract_markdown_autolink(regex)
        # Match until there's no results
        while match = @working_text.match(regex)
          original = match[0]
          length = original.length

          # Find the start position of the original
          start = @working_text.index(original)

          # Create the entity
          entity = {
            type: ENTITY_TYPE_LINK,
            text: original,
            indices: [
              start,
              start + length
            ]
          }

          # Let block modify
          entity = yield(entity, match) if block_given?

          # Add the entity
          @entities << entity

          # Remove from the working text
          @working_text.sub!(original, REPLACE_TOKEN * length)
        end
      end

      def extract_markdown_autolink_links
        extract_markdown_autolink AUTOLINK_LINK_REGEX do |entity, match|
          entity[:url] = match[1]
          entity[:display_text] = display_url(match[1])
          entity
        end
      end

      def extract_markdown_autolink_email
        extract_markdown_autolink AUTOLINK_EMAIL_REGEX do |entity, match|
          email = match[1]
          entity[:url] = "mailto:#{email}"
          entity[:display_text] = email
          entity
        end
      end

      def extract_markdown_links
        extract_markdown_span(LINK_REGEX, ENTITY_TYPE_LINK) do |entity, match|
          # Add the URL
          entity[:url] = match[3]

          # Add the title
          entity[:title] = match[6] if match[6]
          entity
        end
      end
    end
  end
end
