module Quesadilla
  # Default HTML renderer for generating HTML
  class HTMLRenderer
    # HTML representation of italic text
    # @param display_text [String] the italic text
    # @return [String] HTML representation of the italic text
    def emphasis(display_text)
      %Q{<em>#{display_text}</em>}
    end

    # HTML representation of bold text
    # @param display_text [String] the bold text
    # @return [String] HTML representation of the bold text
    def double_emphasis(display_text)
      %Q{<strong>#{display_text}</strong>}
    end

    # HTML representation of bold italic text
    # @param display_text [String] the bold italic text
    # @return [String] HTML representation of the bold italic text
    def triple_emphasis(display_text)
      %Q{<strong><em>#{display_text}</em></strong>}
    end

    # HTML representation of strikethrough text
    # @param display_text [String] the strikethrough text
    # @return [String] HTML representation of the strikethrough text
    def strikethrough(display_text)
      %Q{<del>#{display_text}</del>}
    end

    # HTML representation of code
    # @param display_text [String] the text of the code
    # @return [String] HTML representation of the code
    def code(display_text)
      %Q{<code>#{display_text}</code>}
    end

    # HTML representation of a hashtag
    # @param display_text [String] the hashtag text (`#awesome`)
    # @param hashtag [String] the hashtag (just `awesome`)
    # @return [String] HTML representation of the hashtag
    def hashtag(display_text, hashtag)
      %Q{<a href="#hashtag-#{hashtag}" class="hashtag">#{display_text}</a>}
    end

    # HTML representation of a user mention
    # @param display_text [String] the user mention text (`@soffes`)
    # @param username [String] the username (just `soffes`)
    # @param user_id [String] optional user_id
    # @return [String] HTML representation of the user mention
    def user(display_text, username, user_id = nil)
      %Q{<a href="/#{username}" class="user">#{display_text}</a>}
    end

    # HTML representation of a link
    # @param display_text [String] the text of the link
    # @param url  [String] the url of the link
    # @param title [String] the title of the link
    # @return [String] HTML representation of the link
    def link(display_text, url, title = nil)
      title_attr = (title && title.length > 0) ? %Q{ title="#{title}"} : ''
      %Q{<a href="#{url}" rel="external nofollow" class="link"#{title_attr}>#{display_text}</a>}
    end

    # Post-process entire HTML string
    # @return [String] HTML string
    def post_process(html)
      html
    end
  end
end
