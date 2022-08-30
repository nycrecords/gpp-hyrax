class CreateDeletedPublications < ActiveRecord::Migration[5.0]
  def change
    create_table :deleted_publications do |t|
      t.string :user_guid, null: false
      t.datetime :timestamp, null: false
      t.jsonb :metadata, null: false

      t.timestamps
    end
  end
end
