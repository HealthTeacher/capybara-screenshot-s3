if Object.const_defined?("Test") &&
  module_exists?("Unit", Test) &&
  Test::Unit.const_defined("TestResult")

  Test::Unit::TestResult.class_eval do
    private

    def notify_fault_with_screenshot(fault, *args)
      notify_fault_without_screenshot fault, *args
      is_integration_test = fault.location.any? do |location|
        Capybara::Screenshot.testunit_paths.any? { |path| location.match(path) }
      end
      if is_integration_test
        if Capybara::Screenshot.autosave_on_failure
          Capybara.using_session(Capybara::Screenshot.final_session_name) do
            filename_prefix = Capybara::Screenshot.filename_prefix_for(:testunit, fault)

            saver = Capybara::Screenshot::Saver.new(Capybara, Capybara.page, true, filename_prefix)
            saver.save
            saver.output_screenshot_path
            Capybara::Screenshot::S3.flush if Capybara::Screenshot.upload_to_s3?
          end
        end
      end
    end
  end
end
