class CreateManifests < ActiveRecord::Migration[5.1]
  def change
    create_table :manifests do |t|
      t.string :uuid

      t.timestamps
    end
  end
end
