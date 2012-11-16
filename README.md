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

Generate and run the migration for your table:

    script/generate textable CreateTextableEntries
     
Add this to your model:

    has_textable :my_text

From then on, treat @model.my_text just like you would a standard ActiveRecord attribute.

Also supports serialized hashes like so:

    has_textable :your_hash, :as => 'Hash', :default => { :var_one => "One", :middle_boolean => true, :var_two => "Two" }

Not a good idea for data that you might want to search on, or that needs it's own fields, but for things like
settings you might not want to load all the time, or a bunch of color preferences, or anything where a table
all to itself is overkill.

Whatever you set in has_textable will act as default values if the row in question has no values saved, so you can add
values and have them populated with defaults. Access them like so:

    @model.your_hash[:var_one]

Rock.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
