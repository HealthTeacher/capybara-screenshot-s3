if Object.const_defined?("Spinach")
  Spinach.hooks.after_run do |*args|
    Capybara::Screenshot::S3.flush if Capybara::Screenshot.upload_to_s3?
  end
end
