module Webhooks
  module Entries
    class Creator

      attr_reader :webhook, :remote_entry

      def initialize(webhook, remote_entry)
        @webhook      = webhook
        @remote_entry = remote_entry
      end

      def create
        create_webhook_entry
      end

      private

      def create_webhook_entry
        webhook.webhook_entries.create(attrs)
      end

      def attrs
        @_attrs = {
          timestamp:   format_time(remote_entry["ts"]),
          action:      remote_entry["type"],
          webhookable: local_object
        }
      end

      def local_object
        @_local_object ||= object_base.find_or_create_by(remote_id: remote_entry["objectId"].split(":").last)
      end

      def object_base
        @_object_base ||= begin
          identifier_type = remote_entry["objectId"].split(":").first
          case identifier_type
          when "I"
            Item
          when "O"
            Order
          when "P"
            Payment
          when "C"
            Customer
          end
        end
      end

      def format_time(time)
        nil unless time
        Time.at(time/1000)
      end

    end
  end
end

