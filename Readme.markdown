# Quesadilla

[![Build Status](https://travis-ci.org/soffes/quesadilla.png?branch=master)](https://travis-ci.org/soffes/quesadilla) [![Coverage Status](https://coveralls.io/repos/soffes/quesadilla/badge.png?branch=master)](https://coveralls.io/r/soffes/quesadilla) [![Code Climate](https://codeclimate.com/github/soffes/quesadilla.png)](https://codeclimate.com/github/soffes/quesadilla) [![Dependency Status](https://gemnasium.com/soffes/quesadilla.png)](https://gemnasium.com/soffes/quesadilla) [![Gem Version](https://badge.fury.io/rb/quesadilla.png)](http://badge.fury.io/rb/quesadilla)

Entity-style text parsing. Quesadilla was extracted from [Cheddar](https://cheddarapp.com).

See the [Cheddar text guide](https://cheddarapp.com/text) for more information about how to type entities.

Quesadilla's API is fully documented. Read the [online documentation](http://rubydoc.info/github/soffes/quesadilla/master/frames).


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

Option                      | Description
----------------------------|-----------------------------------------------------------------
`:markdown`                 | All Markdown parsing
`:markdown_code`            | Markdown code tags
`:markdown_links`           | Markdown links (including `<http://soff.es>` style links)
`:markdown_triple_emphasis` | Markdown bold italic
`:markdown_double_emphasis` | Markdown bold
`:markdown_emphasis`        | Markdown italic
`:markdown_strikethrough`   | Markdown Extra strikethrough
`:hashtags`                 | Hashtags
`:hashtags_validator`           | Callable object to validate hashtags
`:autolinks`                | Automatically detect links
`:emoji`                    | GitHub-style named emoji
`:users`                    | User mentions
`:user_validator`           | Callable object to validate usernames
`:html`                     | Generate HTML representations for entities and the entire string

Everything is enabled by deafult except user mentions. If you don't want to extract Markdown, you should call the extractor this like:

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

Take a look at [Quesadilla::HTMLRenderer](lib/quesadilla/html_renderer.rb) for more details on creating a custom renderer.

### Users

To enable user mention extraction, pass `users: true` as an option. You can optionally pass a callable object to validate a username. Here's a quick example:

``` ruby
validator = lambda do |username|
  User.where('LOWER(username) = ?', username.downcase).first.try(:id)
end

extraction = extract('Real @soffes and fake @nobody', users: true, user_validator: validator)
```

Assuming there is a user named `soffes` in your database, it would extract `@soffes`. Assuming there isn't a user named `nobody`, that would remain plain text. Obviously feel free to do whatever you want here. Quesadilla makes no assumptions about your user system.


## Supported Ruby Versions

Quesadilla is tested under 1.9.2, 1.9.3, 2.0.0, JRuby 1.7.2 (1.9 mode), and Rubinius 2.0.0 (1.9 mode).


## Contributing

See the [contributing guide](Contributing.markdown).
