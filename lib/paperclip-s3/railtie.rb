module Paperclip
  module S3
    if defined? Rails::Railtie # Don't break rails 2.x
      require 'rails'
      class Railtie < Rails::Railtie
        initializer 'paperclip.force_s3_attachment_on_production' do
          ActiveSupport.on_load :active_record do
            Paperclip::S3::Railtie.insert
          end
        end
      end
    end

    class Railtie
      def self.insert
        ActiveRecord::Base.send(:include, Paperclip::S3::Glue) if insert?
      end

      private

      def insert?
        ENV['S3_BUCKET'] && ENV['S3_KEY'] && ENV['S3_SECRET']
      end
    end
  end
end
