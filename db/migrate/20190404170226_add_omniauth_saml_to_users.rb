class AddOmniauthSamlToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string, default: '', null: false
    add_column :users, :provider, :string
    add_column :users, :guid, :string, default: '', null: false
    add_column :users, :first_name, :string
    add_column :users, :middle_initial, :string
    add_column :users, :last_name, :string
    add_column :users, :email_validated, :boolean, null: false, default: false
    add_column :users, :active, :boolean, default: false
    add_column :users, :nyc_employee, :boolean, default: false
    add_column :users, :has_nyc_account, :boolean, default: false
  end
end