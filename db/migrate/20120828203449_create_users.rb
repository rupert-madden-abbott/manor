class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.date :deleted_at

      t.timestamps
    end
  end
end
