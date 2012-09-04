class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.belongs_to :user
      t.belongs_to :duty

      t.timestamps
    end
    add_index :preferences, :user_id
    add_index :preferences, :duty_id
  end
end
