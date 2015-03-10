require 'rubygems'
require 'aws-sdk-core'
require 'capybara-screenshot'
require 'capybara-screenshot-s3/helpers'

module Capybara
  module Screenshot

    class << self
      attr_writer :upload_to_s3
    end

    self.upload_to_s3 = false

    def self.screenshot_and_save_page
      saver = Saver.new(Capybara, Capybara.page, true, nil)
      saver.upload_to_s3 = false
      saver.save
      { html: saver.html_location, image: saver.screenshot_location }
    end

    def self.screenshot_and_open_image
      require "launchy"

      saver = Saver.new(Capybara, Capybara.page, false, nil)
      saver.upload_to_s3 = false
      saver.save
      Launchy.open saver.screenshot_location
      { html: nil, image: saver.screenshot_location }
    end

    def self.upload_to_s3?
      @upload_to_s3 == true
    end

    module S3
      US_STANDARD_REGION = "us-east-1"

      class << self
        def configure(&block)
          @uploader = Uploader.new
          @uploader.instance_eval(&block)
          @uploader.validate
          Capybara::Screenshot.upload_to_s3 = true
          @paths_to_upload = []
        end

        def enqueue(path)
          @paths_to_upload << path
        end

        def flush
          @paths_to_upload.each { |path| @uploader.upload(path) }
          @paths_to_upload = []
        end

        def upload(path)
          @uploader.upload(path)
        end

        def url_for(path)
          @uploader.url_for(path)
        end

        class Uploader
          attr_writer :access_key_id
          attr_writer :bucket
          attr_writer :folder
          attr_writer :region
          attr_writer :secret_access_key

          def upload(path)
            client.put_object(bucket: bucket, key: key(path), body: IO.read(path), acl: "public-read")
          end

          def url_for(path)
            "https://s3#{region_url_segment}.amazonaws.com/#{bucket}/#{key(path)}"
          end

          def validate
            unless bucket
              raise "Capybara::Screenshot::S3 - You must specify a bucket for S3 uploads"
            end
          end

          private
          def bucket
            @s3_bucket ||= @bucket.respond_to?(:call) ? @bucket.call : @bucket
          end

          def client
            @client ||= Aws::S3::Client.new(client_options)
          end

          def client_options
            options = { region: region }
            options[:credentials] = credentials if credentials
            options
          end

          def credentials
            @credentials ||= if @access_key_id && @secret_access_key
              Aws::Credentials.new(@access_key_id, @secret_access_key)
            end
          end

          def folder
            @s3_folder ||= @folder.respond_to?(:call) ? @folder.call : @folder
          end

          def key(path)
            s3_key = File.basename(path)
            s3_key = File.join(folder, s3_key) if folder
            s3_key
          end

          def region
            @s3_region ||= @region || US_STANDARD_REGION
          end

          def region_is_us_standard?
            region == US_STANDARD_REGION
          end

          def region_url_segment
            region_is_us_standard? ? nil : "-#{region}"
          end
        end
      end
    end
  end
end

Dir["#{File.dirname(__FILE__)}/capybara-screenshot-s3/capybara-screenshot/**/*.rb"].each {|f| require f}
