class CreateDeletedPublications < ActiveRecord::Migration[5.1]
  def change
    create_table :deleted_publications do |t|
      t.string :user_guid
      t.datetime :timestamp
      t.jsonb :metadata

      t.timestamps
    end
  end
end
