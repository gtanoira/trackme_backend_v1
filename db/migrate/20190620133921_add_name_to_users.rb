class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string, null: true, comment: 'First Name'
    add_column :users, :last_name,  :string, null: true, comment: 'Last Name'
  end
end
