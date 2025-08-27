class CreateAgencyAliases < ActiveRecord::Migration[5.2]
  def change
    create_table :agency_aliases do |t|
      t.references :primary_agency, null: false, foreign_key: { to_table: :agencies }
      t.references :alias_agency, null: false, foreign_key: { to_table: :agencies }

      t.timestamps
    end

    add_index :agency_aliases, [:primary_agency_id, :alias_agency_id], unique: true
  end
end
