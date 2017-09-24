class AddContentToManifest < ActiveRecord::Migration[5.1]
  def change
    add_column :manifests, :content, :jsonb, null: false, default: {}
  end
end
