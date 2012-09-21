class AddPersonalDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :extension, :string
    add_column :users, :mobile, :string
    add_column :users, :residence, :string
    add_column :users, :email, :string
    add_column :users, :responsibilites, :string
  end
end
