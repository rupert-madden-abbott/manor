class CreateRota < ActiveRecord::Migration
  def change
    create_table :rota do |t|
      t.date :starts
      t.date :ends
      t.boolean :assigned

      t.timestamps
    end

    add_column :duties, :rotum_id, :integer
    add_index :duties, :rotum_id, name: 'rotum_id'
  end
end
