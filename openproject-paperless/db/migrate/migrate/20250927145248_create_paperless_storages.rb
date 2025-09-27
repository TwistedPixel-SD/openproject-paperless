class CreatePaperlessStorages < ActiveRecord::Migration[7.0]
  def change
    create_table :paperless_storages do |t|
      t.string :name, null: false
      t.string :host, null: false
      t.string :api_token_encrypted, null: false
      t.references :project, foreign_key: true, null: false
      t.boolean :automatically_managed, default: false
      t.jsonb :configuration, default: {}
      t.timestamps
    end

    create_table :paperless_file_links do |t|
      t.references :storage, foreign_key: { to_table: :paperless_storages }, null: false
      t.references :work_package, foreign_key: true, null: false
      t.references :creator, foreign_key: { to_table: :users }, null: false
      t.string :document_id, null: false
      t.string :document_name, null: false
      t.string :document_url
      t.jsonb :document_metadata, default: {}
      t.timestamps
    end

    add_index :paperless_file_links, [:work_package_id, :document_id], 
              unique: true, 
              name: 'index_paperless_links_on_wp_and_doc'
    
    add_index :paperless_storages, :project_id
    add_index :paperless_file_links, :document_id
  end
end
