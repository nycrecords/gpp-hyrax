class CreateAgencies < ActiveRecord::Migration[5.1]
  def change
    create_table :agencies do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :point_of_contact_emails, array: true, default: []

      t.timestamps
    end
  end
end
