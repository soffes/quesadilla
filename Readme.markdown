# Quesadilla

Entity-style text parsing. Quesadilla was extracted from [Cheddar](https://cheddarapp.com).

See the [Cheddar text guide](https://cheddarapp.com/text) for more information about how to type entities.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'quesadilla'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quesadilla

## Usage

To extract entites from text, simply call extract:

``` ruby
Quesadilla.extract('Some #awesome text')
# => {
#   display_text: "Some #awesome text",
#   display_html: "Some <a href=\"#hashtag-awesome\" class=\"tag\">#awesome</a> text",
#   entities: [
#     {
#       type: "hashtag",
#       text: "#awesome",
#       display_text: "#awesome",
#       indices: [5, 13],
#       hashtag: "awesome",
#       display_indices: [5, 13]
#     }
#   ]
# }
```

### Configuring

Quesadilla supports extracting various span-level Markdown features as well as automatically detecting links and GitHub-style named emoji. Here are the list of options you can pass when extracting:

Option                    | Description
--------------------------|------------
`:markdown`               | All Markdown parsing
`:markdown_code`          | Markdown code tags
`:markdown_links`         | Markdown links (including `<http://soff.es>` style links)
`:markdown_bold_italic`   | Markdown bold italic
`:markdown_bold`          | Markdown bold
`:markdown_italic`        | Markdown italic
`:markdown_strikethrough` | Markdown Extra strikethrough
`:hashtags`               | Hashtags
`:autolinks`              | Automatically detect links
`:emoji`                  | GitHub-style named emoji
`:html`                   | Generate HTML representations for entities and the entire string

Everything is enabled by deafult. If you don't want to extract Markdown, you should call the extractor this like:

``` ruby
Quesadilla.extract('Some text', markdown: false)
```

You can also just disable strikethrough and still extract the rest of the Markdown entities if you want:

``` ruby
Quesadilla.extract('Some text', markdown_strikethrough: false)
```

### Customizing HTML

If you want to change the generated HTML, you can create a custom renderer:

``` ruby
class CustomRenderer < Quesadilla::HTMLRenderer
  def hashtag(display_text, hashtag)
    %Q{<a href="http://example.com/tags/#{hashtag}" class="tag">#{display_text}</a>}
  end
end

extraction = Quesadilla.extract('Some #awesome text', html_renderer: CustomRenderer)
extraction[:display_html] #=> 'Some <a href="http://example.com/tags/awesome" class="tag">#awesome</a> text'
```

Take a look at [Quesadilla::HTMLRenderer](lib/quesadilla/html_renderer.html) for more details on creating a custom renderer.

## Supported Ruby Versions

Quesadilla is tested under 1.9.3, 2.0.0, and JRuby (1.9 mode).

[![Build Status](https://travis-ci.org/soffes/quesadilla.png?branch=master)](https://travis-ci.org/soffes/quesadilla)

## Contributing

See the [contributing guide](Contributing.markdown).
