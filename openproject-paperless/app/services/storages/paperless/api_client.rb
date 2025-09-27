module Storages
  module Paperless
    class ApiClient
      include HTTParty

      def initialize(base_url, api_token)
        @base_url = base_url.chomp('/')
        @headers = {
          'Authorization' => "Token #{api_token}",
          'Content-Type' => 'application/json'
        }
      end

      # Search documents
      def search_documents(query: nil, tags: [], correspondent: nil, page: 1)
        params = {
          page: page,
          page_size: 20
        }
        params[:query] = query if query.present?
        params[:tags__id__in] = tags.join(',') if tags.any?
        params[:correspondent__id] = correspondent if correspondent.present?

        response = self.class.get(
          "#{@base_url}/api/documents/",
          headers: @headers,
          query: params
        )

        handle_response(response)
      end

      # Get document details
      def get_document(document_id)
        response = self.class.get(
          "#{@base_url}/api/documents/#{document_id}/",
          headers: @headers
        )

        handle_response(response)
      end

      # Get document file
      def download_document(document_id)
        response = self.class.get(
          "#{@base_url}/api/documents/#{document_id}/download/",
          headers: @headers
        )

        handle_response(response)
      end

      # Get document preview
      def get_preview(document_id)
        response = self.class.get(
          "#{@base_url}/api/documents/#{document_id}/preview/",
          headers: @headers
        )

        handle_response(response)
      end

      # Upload document
      def upload_document(file, title: nil, tags: [], correspondent: nil)
        body = {
          document: file,
          title: title,
          tags: tags,
          correspondent: correspondent
        }.compact

        response = self.class.post(
          "#{@base_url}/api/documents/post_document/",
          headers: @headers.except('Content-Type'),
          body: body
        )

        handle_response(response)
      end

      # Get tags
      def get_tags
        response = self.class.get(
          "#{@base_url}/api/tags/",
          headers: @headers
        )

        handle_response(response)
      end

      # Get correspondents
      def get_correspondents
        response = self.class.get(
          "#{@base_url}/api/correspondents/",
          headers: @headers
        )

        handle_response(response)
      end

      private

      def handle_response(response)
        case response.code
        when 200, 201
          JSON.parse(response.body, symbolize_names: true)
        when 401
          raise AuthenticationError, 'Invalid API token'
        when 404
          raise NotFoundError, 'Resource not found'
        else
          raise ApiError, "API request failed: #{response.code} - #{response.body}"
        end
      end

      class ApiError < StandardError; end
      class AuthenticationError < ApiError; end
      class NotFoundError < ApiError; end
    end
  end
end