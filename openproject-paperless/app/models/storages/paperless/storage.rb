module Storages
  module Paperless
    class Storage < ApplicationRecord
      self.table_name = 'paperless_storages'

      belongs_to :project
      has_many :file_links, class_name: 'Storages::Paperless::FileLink', dependent: :destroy

      validates :name, presence: true
      validates :host, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(['http', 'https']) }
      validates :api_token, presence: true

      encrypts :api_token

      def api_client
        @api_client ||= ApiClient.new(host, api_token)
      end

      def test_connection
        api_client.get_tags
        true
      rescue ApiClient::ApiError => e
        errors.add(:base, "Connection failed: #{e.message}")
        false
      end
    end
  end
end