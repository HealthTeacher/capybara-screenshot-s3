module Capybara
  module Screenshot
    class Saver
      attr_writer :upload_to_s3

      def save_html_with_upload
        save_html_without_upload
        enqueue_upload(html_path) if upload_to_s3?
      end
      alias_method :save_html_without_upload, :save_html
      alias_method :save_html, :save_html_with_upload

      def save_screenshot_with_upload
        save_screenshot_without_upload
        enqueue_upload(screenshot_path) if @screenshot_saved && upload_to_s3?
      end
      alias_method :save_screenshot_without_upload, :save_screenshot
      alias_method :save_screenshot, :save_screenshot_with_upload

      def html_location
        upload_to_s3? ? url_for(html_path) : html_path
      end

      def screenshot_location
        upload_to_s3? ? url_for(screenshot_path) : screenshot_path
      end

      def output_screenshot_path
        output "HTML screenshot: #{html_location}" if html_saved?
        output "Image screenshot: #{screenshot_location}" if screenshot_saved?
      end

      private
      def upload_to_s3?
        @should_upload ||= @upload_to_s3.nil? ? Capybara::Screenshot.upload_to_s3? : @upload_to_s3
      end

      def url_for(path)
        Capybara::Screenshot::S3.url_for(path)
      end

      def enqueue_upload(path)
        Capybara::Screenshot::S3.enqueue(path)
      end
    end
  end
end
