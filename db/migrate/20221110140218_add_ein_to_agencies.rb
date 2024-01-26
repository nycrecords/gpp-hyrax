class AddEinToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :ein, :string
  end
end
