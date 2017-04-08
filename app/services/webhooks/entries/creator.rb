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
          timestamp:   timestamp,
          action:      action,
          webhookable: local_object
        }
      end

      def local_object
        @_local_object ||= object_base.find_or_create_by(remote_id: remote_id)
      end

      def object_base
        @_object_base ||= begin
          case identifier_type
          when "I"
            Item
          when "O"
            Order
          when "P"
            Payment
          when "C"
            Customer
          when "chk"
            Check
          when "ltr"
            Letter
          end
        end
      end

      def timestamp
        if webhook.clover?
          format_time(remote_entry["ts"])
        elsif webhook.lob?
          remote_entry["date_created"].to_datetime
        end
      end

      def format_time(time)
        nil unless time
        Time.at(time/1000)
      end

      def identifier_type
        if webhook.clover?
          remote_entry["objectId"].split(":").first
        elsif webhook.lob?
          remote_entry["body"]["id"].split("_").first
        end
      end

      def remote_id
        if webhook.clover?
          remote_entry["objectId"].split(":").last
        elsif webhook.lob?
          remote_entry["body"]["id"]
        end
      end

      def action
        if webhook.clover?
          remote_entry["type"]
        elsif webhook.lob?
          remote_entry["event_type"]["id"].split(".").last
        end
      end

    end
  end
end
