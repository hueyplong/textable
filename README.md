# Textable

Rails utility for keeping TEXT fields out of your Model tables and in their
own little world. Useful for MySQL table optimization if you have models
that need TEXT fields and don't want to clutter your schema with them. Variable
length fields like TEXT and BLOB will force MySQL to sort on disk, so moving
those fields to their own table makes for nicer performance.

## Installation

Add this line to your application's Gemfile:

    gem 'textable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install textable

## Usage

Add this to your model:

    has_textable :my_text

From then on, treat @model.my_text just like you would a standard ActiveRecord attribute.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
