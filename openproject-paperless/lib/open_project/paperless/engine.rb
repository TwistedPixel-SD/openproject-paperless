# frozen_string_literal: true

# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require "open_project/plugins"

module OpenProject::Paperless
  class Engine < ::Rails::Engine
    engine_name :openproject_paperless

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-paperless',
               author_url: 'https://github.com/yourusername',
               bundled: false,
               settings: {
                 default: {
                   'paperless_instances' => []
                 }
               } do
        
        # Register the Paperless storage provider
        project_module :storages do
          permission :manage_paperless_files,
                     { 'storages/paperless/files': [:index, :show, :download] },
                     permissible_on: :project
          permission :link_paperless_files,
                     { 'storages/paperless/file_links': [:create, :destroy] },
                     permissible_on: :work_package
        end

        # Add menu item
        menu :project_menu,
             :paperless_files,
             { controller: '/storages/paperless/files', action: 'index' },
             after: :files,
             caption: :label_paperless_files,
             icon: 'icon2 icon-folder-open'

        # Register storage type
        storage_type :paperless,
                     label: 'Paperless-ngx',
                     icon: 'icon2 icon-folder-open'
      end

      # Load patches
      config.to_prepare do
        require_relative 'patches/work_package_patch'
      end

      # Add frontend assets
      assets %w[
        paperless/paperless.css
        paperless/paperless.js
      ]

      # Register API endpoints
      add_api_endpoint 'API::V3::Storages::Paperless::StoragesAPI'
      add_api_endpoint 'API::V3::Storages::Paperless::FilesAPI'

      initializer 'paperless.register_hooks' do
        # Register hooks for work package tabs
        OpenProject::Hook.register :view_work_packages_tabs do |context|
          if context[:project].module_enabled?(:storages)
            {
              name: 'paperless',
              label: :label_paperless_documents,
              path: paperless_files_work_package_path(context[:work_package])
            }
          end
        end
      end
    end
  end
end
