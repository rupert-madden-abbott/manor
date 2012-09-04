class CreateDutiesUsers < ActiveRecord::Migration
  def change
    create_table :duties_users, id: false do |t|
      t.references :duty, null: false
      t.references :user, null: false
    end

    add_index :duties_users, [:duty_id, :user_id], unique: true
    add_column :duties, :user_id, :integer
    add_index :duties, :user_id
  end
end
