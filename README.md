capybara-screenshot-s3 gem
=======================

`capybara-screenshot-s3` allows you to easily upload `capybara-screenshot`
screenshots to Amazon S3.

Installation
-----

### Step 1: install the gem

Using Bundler, add the following to your Gemfile

```ruby
gem 'capybara-screenshot-s3', group: :test, require: false
```

or install manually using Ruby Gems:

```
gem install capybara-screenshot-s3
```

### Step 2: Require capybara-screenshot-s3

In rails_helper.rb, spec_helper.rb, or a support file, after the `capybara-screenshot` requires, add:

```ruby
# or require 'capybara-screenshot/minitest' etc.
require 'capybara-screenshot/rspec'

# remember: you must require 'capybara-screenshot-s3' after the appropriate
#`capybara-screenshot` driver (Cucumber, RSpec, MiniTest, etc.)
require 'capybara-screenshot-s3'
```

Step 3: Configuration
--------------------------

In rails_helper.rb, spec_helper.rb, or a support file:

```ruby
Capybara::Screenshot::S3.configure do |config|
  config.access_key_id = "YOUR_ACCESS_KEY_ID"
  config.secret_access_key = "YOUR_SECRET_ACCESS_KEY"

  # bucket name - required. this can be a string or a Proc
  config.bucket = "some-bucket"

  # optionally, specify as folder in which to store the screenshots
  # can be a string or a Proc
  config.folder = ->{
    if build_number = ENV["BUILD_NUMBER"]
      "builds/#{build_number}"
    end
  }
end
```

License
-------

Copyright © 2014 HealthTeacher, Inc. It is free software, and may be redistributed under the terms specified in the LICENSE file.
