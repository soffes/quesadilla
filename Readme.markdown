# Quesadilla

Entity-style text parsing.

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
#      display_text: "Some #awesome text",
#      entities: [
#        {
#          type: "hashtag",
#          text: "#awesome",
#          display_text: "#awesome",
#          indices: [5, 13],
#          hashtag: "awesome",
#          display_indices: [5, 13]
#        }
#      ],
#      display_html: "Some <a href=\"#hashtag-awesome\" class=\"tag\">#awesome</a> text"
#    }
```

### Configuring

Quesadilla supports extracting the following:

``` ruby
DEFAULT_OPTIONS = {
  markdown: true,
  markdown_code: true,
  markdown_links: true,
  markdown_bold_italic: true,
  markdown_bold: true,
  markdown_italic: true,
  markdown_strikethrough: true,
  hashtags: true,
  autolinks: true,
  emoji: true,
  html: true
}
```

You can see they are all on by default. If you don't want to extract Markdown, you should call the extractor this like:

``` ruby
Quesadilla.extract('Some text', markdown: false)
```

There is also fine grain control over which Markdown entities it extracts.

### Hashtag Links

If you want to change the HTML links generated for hashtags, simply set the format:

``` ruby
extraction = Quesadilla.extract('Some text', hashtag_url_format: 'http://example.com/hashtags/HASHTAG', hashtag_class_name: 'tag')
extraction[:display_html] #=> 'Something <a href="http://example.com/tags/tagged" class="hashtag">#tagged</a>'
```

## Supported Ruby Versions

Quesadilla is tested under 1.9.3, 2.0.0, and JRuby (1.9 mode).

[![Build Status](https://travis-ci.org/soffes/quesadilla.png?branch=master)](https://travis-ci.org/soffes/quesadilla)

## Contributing

See the [contributing guide](Contributing.markdown).
