module Storages
  module Paperless
    class FilesController < ApplicationController
      before_action :find_project
      before_action :find_storage
      before_action :authorize

      def index
        @query = params[:q]
        @page = params[:page] || 1
        
        @documents = @storage.api_client.search_documents(
          query: @query,
          page: @page
        )

        respond_to do |format|
          format.html
          format.json { render json: @documents }
        end
      end

      def show
        @document = @storage.api_client.get_document(params[:id])
        
        respond_to do |format|
          format.html
          format.json { render json: @document }
        end
      end

      def download
        document_data = @storage.api_client.download_document(params[:id])
        
        send_data document_data,
                  filename: params[:filename],
                  type: 'application/pdf',
                  disposition: 'attachment'
      end

      def link_to_work_package
        work_package = WorkPackage.find(params[:work_package_id])
        
        file_link = FileLink.create!(
          storage: @storage,
          work_package: work_package,
          creator: current_user,
          document_id: params[:document_id],
          document_name: params[:document_name]
        )

        respond_to do |format|
          format.json { render json: file_link }
        end
      end

      private

      def find_project
        @project = Project.find(params[:project_id])
      end

      def find_storage
        @storage = @project.paperless_storages.first
      end
    end
  end
end