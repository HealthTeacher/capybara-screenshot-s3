require "capybara-screenshot"

if Capybara::Screenshot::S3.module_exists?("RSpec", Capybara::Screenshot)
  module Capybara
    module Screenshot
      module RSpec
        class << self
          def after_failed_example_with_upload(example)
            after_failed_example_without_upload(example)

            return unless example.metadata[:screenshot]

            if html_path = example.metadata[:screenshot][:html]
              example.metadata[:screenshot][:html] = Capybara::Screenshot::S3.url_for(html_path)
            end

            if screenshot_path = example.metadata[:screenshot][:image]
              example.metadata[:screenshot][:image] = Capybara::Screenshot::S3.url_for(screenshot_path)
            end
          end

          alias_method :after_failed_example_without_upload, :after_failed_example
          alias_method :after_failed_example, :after_failed_example_with_upload
        end
      end
    end
  end

  RSpec.configure do |config|
    config.after(:suite) do
      Capybara::Screenshot::S3.flush if Capybara::Screenshot.upload_to_s3?
    end
  end
end
