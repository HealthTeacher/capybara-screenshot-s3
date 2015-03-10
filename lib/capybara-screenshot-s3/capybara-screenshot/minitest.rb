if Capybara::Screenshot::S3.module_exists?("MiniTestPlugin", Capybara::Screenshot)
  module Capybara::Screenshot::MiniTestPlugin
    def after_tests
      super
      Capybara::Screenshot::S3.flush if Capybara::Screenshot.upload_to_s3?
    end
  end
end
