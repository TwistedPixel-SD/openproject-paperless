module Storages
  module Paperless
    class FileLink < ApplicationRecord
      self.table_name = 'paperless_file_links'

      belongs_to :storage, class_name: 'Storages::Paperless::Storage'
      belongs_to :work_package
      belongs_to :creator, class_name: 'User'

      validates :document_id, presence: true, uniqueness: { scope: :work_package_id }
      validates :document_name, presence: true

      def document_data
        @document_data ||= storage.api_client.get_document(document_id)
      end

      def download_url
        "#{storage.host}/api/documents/#{document_id}/download/"
      end

      def preview_url
        "#{storage.host}/api/documents/#{document_id}/preview/"
      end
    end
  end
end