class AddUniqueSessionIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unique_session_id, :string
  end
end
