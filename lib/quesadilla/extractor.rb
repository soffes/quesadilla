# encoding: UTF-8

module Quesadilla
  class Extractor
    require 'quesadilla/core_ext/string'
    Dir[File.expand_path('../extractor/*.rb', __FILE__)].each { |f| require f }

    include Autolinks
    include Emoji
    include Hashtags
    include HTML
    include Markdown

    # Invisible character from the reserved range replaces markdown we've already parsed.
    REPLACE_TOKEN = "\uf042"

    def self.default_options
      {
        :markdown => true,
        :markdown_code => true,
        :markdown_links => true,
        :markdown_bold_italic => true,
        :markdown_bold => true,
        :markdown_italic => true,
        :markdown_strikethrough => true,
        :hashtags => true,
        :hashtag_url_format => '#hashtag-HASHTAG',
        :hashtag_class_name => 'hashtag',
        :autolinks => true,
        :emoji => true,
        :html => true,
        :html_renderer => Quesadilla::HTMLRenderer
      }
    end

    def initialize(options = {})
      @options = self.class.default_options.merge(options)
      @renderer = @options[:html_renderer].new if @options[:html]
    end

    def extract(original_text)
      @original_text = original_text.dup

      # Emoji colon-syntax
      replace_emoji if @options[:emoji]

      @working_text = @original_text.dup
      @entities = []

      # Get entities
      extract_markdown if @options[:markdown]
      extract_hashtags if @options[:hashtags]
      extract_autolinks if @options[:autolinks]

      # Sort entities
      @entities.sort! do |a, b|
        a[:indices].first <=> b[:indices].first
      end

      # Adjust display for each entity
      display_text = sub_entities(@original_text, @entities)

      # Return
      hash = {
        display_text: display_text,
        entities: @entities
      }
      hash[:display_html] = display_html(display_text, @entities) if @options[:html]
      hash
    end

  private

    def display_url(url)
      url = url.gsub(/(?:https?:\/\/)?(?:www\.)?/i, '').q_truncate(32, omission: '…')
      url = url[0...(url.length - 1)] if url[-1, 1] == '/'
      url
    end

    def quality_url(url)
      return url if url.include?('://')
      'http://' + url
    end

    def sub_entities(input_text, entities, display = false, &block)
      # Adjust output text for each entity
      output_text = input_text
      offset = 0
      entities.each do |entity|
        entity_original_text = display ? entity[:display_text] : entity[:text]
        entity_display_text = if block_given?
          yield(entity)
        else
          entity[:display_text]
        end

        indices = display ? entity[:display_indices] : entity[:indices]

        # Use the entity's display text instead of original text if they're different
        unless entity_original_text == entity_display_text
          # Get the fragment before the entity
          bf_end = indices[0] - 1 - offset
          before_frag = bf_end <= 0 ? '' : output_text[0..bf_end]

          # Get the fragment after the entity
          af_start = indices[1] - offset
          af_end = output_text.length - 1
          after_frag = af_start > af_end ? '' : output_text[af_start..af_end]

          # Update the output text
          output_text = before_frag + entity_display_text + after_frag
        end

        # Update offset
        adjust = entity_original_text.length - entity_display_text.length
        unless display
          entity[:display_indices] = [entity[:indices][0] - offset, entity[:indices][1] - offset - adjust]
        end
        offset += adjust
      end
      output_text
    end
  end
end
