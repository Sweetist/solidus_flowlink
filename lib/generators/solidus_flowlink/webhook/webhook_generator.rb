module SolidusFlowlink
  module Generators
    class WebhookGenerator < Rails::Generators::Base

      desc "Generates a webhook handler class"
      source_root File.expand_path("../templates", __FILE__)
      argument :webhook_name, :type => :string,  desc: "the webhook name to add"

      attr_accessor :existing_handler

      def generate
        @existing_handler = false
        webhook_handler_file = "#{webhook_name}_handler.rb"
        Dir.glob(File.join(File.dirname(__FILE__), "../../../**/*_handler.rb")) do |handler|
          if File.basename(handler) == webhook_handler_file
            @existing_handler = true
            say %Q{
              #{'*' * 80}
              [WARNING] overriding an extising handler defined here: #{File.absolute_path handler}
              #{'*' * 80}
            }
          end
        end
        template "webhook.rb.tt", "lib/spree/flowlink/handler/#{webhook_handler_file}"
      end

      private
      def handler_class
        webhook_name.camelize + "Handler"
      end

      def handler_object
        webhook_name.split("_").last
      end

    end
  end
end
