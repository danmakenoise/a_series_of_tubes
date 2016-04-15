# ASeriesOfTubes

This is a simple web development framework built in Ruby! It is currently under development, so stay tuned for more updates!

[Sample Server](http://www.github.com/rake-db-migrate/a_series_of_tubes_demo)
[Live Link](http://aseriesoftubes-demo.herokuapp.com)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'a_series_of_tubes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install a_series_of_tubes

## Usage

**A Series of Tubes** is a toolset for creating simple RESTful websites in Ruby. If you are interested in learning how to use it in your project, check out the [[Sample Server](http://www.github.com/rake-db-migrate/a_series_of_tubes_demo) for a suggested application structure.

There are four main components to **A Series of Tubes**:

### Tubes

Tubes are the individual routes users can navigate on your server. You can create a `Tube` via the `Tuber` class. An example set-up is as follows:

```ruby
tuber = ASeriesOfTubes::Tubes::Tuber.new

tuber.draw do
  get  Regexp.new('^/$'),         CatsController, :index
  get  Regexp.new('^/cats$'),     CatsController, :index
  get  Regexp.new('^/cats/new$'), CatsController, :new
  post Regexp.new('^/cats$'),     CatsController, :create
end
```

The `Tuber` itself is mainly useful as a means for creating the various instances of `Tube` using its `draw` function. Within `draw` you create a `Tube` with the following syntax:

```ruby
  METHOD REGEX_FOR_PATH, TUBE_CONTROLLER_NAME, TUBE_CONTROLLER_ACTIONS

  # METHOD can be get, post, put, or delete
```

### TubeController

The `TubeController` is the class that will actually render your HTML/ERB views. For example, in our sample server, the `CatsController#index` action looks like this:

```ruby
class CatsController < ASeriesOfTubes::TubeController
  def index
    @cats = get_cats_from_cookies
  end

  def get_cats_from_cookies
    session['cats'] ? session['cats'] : []
  end
end
```

When a `Tube` gets matched to the `index` action, an instance variable `@cats` is created and is populated with any data in the session cookie under the key `cats`. This is another important feature of the `TubeController`! You can user `session[KEY]` to store data to the session cookies of the site. Similarly, there is `flash[KEY]` and `flash.now[KEY]`, which can be used to only store information for the next render or redirect.

### TubeSupport

This module just contains helper functions for the entire gem.

### TubeState

This module contains the internal workings of the `session` and `flash` abilities of the `TubeController` class.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rake-db-migrate/a_series_of_tubes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
